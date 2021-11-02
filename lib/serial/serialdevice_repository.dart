import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:async/async.dart';

import 'package:inavconfigurator/msp/codes.dart';
import 'package:inavconfigurator/msp/codes/api_version.dart';
import 'package:inavconfigurator/msp/codes/base_data_handler.dart';
import 'package:inavconfigurator/msp/codes/fcvariant.dart';
import 'package:inavconfigurator/msp/writers/base_data_writer.dart';
import 'package:inavconfigurator/serial/list_index.dart';
import 'package:inavconfigurator/serial/periphery_provider.dart';

import '../msp/data_transformers.dart';
import '../msp/msp_message.dart';
import 'serialport_model.dart';

enum SerialDeviceEventType { connected, connecting, disconnected }

class SerialDeviceEvent {
  SerialDeviceEvent(this.type);

  final SerialDeviceEventType type;
}

class SerialDeviceRepository {
  final identifier = new Queue<int>();
  late SerialPortInfo serialPortInfo;
  late Map<int, StreamController<MSPMessageResponse>> streamMaps = {};

  late bool _blockRead;
  final _errorStreamController = StreamController<String>.broadcast();
  late bool _packetLocak = false;
  final SerialDeviceProviderPeriphery _provider =
      new SerialDeviceProviderPeriphery();

  final StreamController<List<int>> _readStream =
      new StreamController<List<int>>();

  final _responseMessagesStreamController =
      StreamController<MSPMessageResponse>.broadcast();

  final _responseRawStreamController = StreamController<List<int>>.broadcast();
  final _serialPortStreamController =
      StreamController<SerialDeviceEvent>.broadcast();

  late Timer _streamTimer;

  StreamSink<MSPMessageResponse> get responseMessagesSink =>
      _responseMessagesStreamController.sink;

  Stream<MSPMessageResponse> get responseMessages =>
      _responseMessagesStreamController.stream;

  Stream<SerialDeviceEvent> get serialPortDevice =>
      _serialPortStreamController.stream;

  StreamSink<SerialDeviceEvent> get _serialPortDeviceSink =>
      _serialPortStreamController.sink;

  StreamSink<List<int>> get responseRawSink =>
      _responseRawStreamController.sink;

  Stream<List<int>> get responseRaw => _responseRawStreamController.stream;

  Stream<String> get serialPortDeviceError => _errorStreamController.stream;

  Future<bool> connect(SerialPortInfo serialPortInfo) async {
    this.serialPortInfo = serialPortInfo;
    // Inform app we are connecting
    final newConnectingEvent =
        new SerialDeviceEvent(SerialDeviceEventType.connecting);
    this._serialPortDeviceSink.add(newConnectingEvent);

    String path = serialPortInfo.name;
    bool connected = _provider.connect(path);

    if (!connected) {
      print("Not connected $path");
      return false;
    }

    this.readListen();

    await this._checkApiVersion();
    await this._checkFCFvarient();

    // Start a heartbeat to track disconnecting
    // this._startHeartBeat();

    // Notify app of connection
    final newConnectedEvent =
        new SerialDeviceEvent(SerialDeviceEventType.connected);
    this._serialPortDeviceSink.add(newConnectedEvent);

    return connected;
  }

  _checkApiVersion() async {
    print("Getting API versions");

    try {
      MSPApiVersion? apiVersion = await this
          .writeFuncWithResponseAs<MSPApiVersion>(MSPCodes.mspApiVersion);

      // Check we are version compatible?
      if (apiVersion == null || apiVersion.apiVersionMajor < 2) {
        this.close();
        throw new Exception("Failed version check. ${apiVersion?.apiVersion}");
      }

      print("Detected API Version ${apiVersion.apiVersion}");
      return true;
    } catch (e) {
      throw new Exception("Failed to get API version");
    }
  }

  _checkFCFvarient() async {
    try {
      MSPFcVariant? mspFcVariant = await this
          .writeFuncWithResponseAs<MSPFcVariant>(MSPCodes.mspFcVariant);

      // Check we are using INAV on the board
      if (mspFcVariant == null ||
          mspFcVariant.flightControllerIdentifier != "INAV") {
        this.close();
        throw new Exception(
            "Failed flight controller identification. ${mspFcVariant?.flightControllerIdentifier}");
      }

      print(mspFcVariant);
      print("Detected Fc Variant $mspFcVariant");
      return true;
    } catch (e) {
      throw new Exception("Failed flight controller identification");
    }
  }

  Future<T?> writeFuncWithResponseAs<T>(int code) async {
    int written = this.writeFunc(code);
    if (written <= 0) {
      return null;
    }

    // Wait for response
    return this.responseAs<T>(code);
  }

  Future<MSPMessageResponse> response(Stream<MSPMessageResponse> stream) async {
    Stream<MSPMessageResponse> newStream =
        stream.timeout(Duration(seconds: 10));

    var value;
    await for (var data in newStream) {
      return data;
    }

    return value;
  }

  Future<T> responseAs<T>(int code) async {
    Stream<MSPMessageResponse> stream = this.responseStream(code);
    MSPMessageResponse messageResponse = await this.response(stream);
    return this.transform(code, messageResponse);
  }

  readListen() {
    // Duration timerDuration = Duration(milliseconds: 1);
    // this._streamTimer = Timer.periodic(timerDuration, this._readPoll);

    _provider.dataStream.listen((List<int> data) {
      responseRawSink.add(data);
      this.identifier.addAll(data);
      _findPackets();
    });

    // _provider.data.listen(this._gotData);
  }

  // _readPoll(Timer timer) {
  //   this._doReadPoll();
  // }

  _findPackets() async {
    if (this._packetLocak) {
      return;
    }

    this._packetLocak = true;
    List<int> allData = identifier.toList();

    if (allData.length <= 0) {
      this._packetLocak = false;
      return;
    }

    List<int> header = [36, 88, 62, 0];
    print("identifier.length before ${identifier.length}");

    // 36, 88, 62, 0,
    int hasHeader = allData.indexOfElements(header);

    if (hasHeader > -1) {
      int l = allData[6];
      l |= allData[7] << 8;

      int p = 8 + l + 1;

      List<int> subData = allData.sublist(hasHeader, hasHeader + p);
      if (subData.length > 0) {
        _readStream.add(subData);
        this._gotData(subData);
      }

      for (var i = 0; i < hasHeader + subData.length; i++) {
        identifier.removeFirst();
      }
    }

    print("identifier.length after ${identifier.length}");
    this._packetLocak = false;
  }

  // _doReadPoll() {
  //   try {
  //     _findPackets();
  //     int waiting = this._provider.getInputWaiting();

  //     if (this._blockRead || waiting <= 0) {
  //       return;
  //     }

  //     this._blockRead = true;

  //     List<int> allData = [];
  //     while (waiting > 0) {
  //       List<int> data = this._provider.read(waiting, 0);
  //       allData.addAll(data);
  //       waiting = this._provider.getInputWaiting();
  //     }

  //     identifier.addAll(allData);
  //   } catch (e) {
  //     // if (e is SerialPortError &&
  //     //     e.errorCode == SerialErrorCode.SERIAL_ERROR_IO.index) {
  //     //   this.close();
  //     // }

  //     print(e);
  //   }

  //   this._blockRead = false;
  // }

  close() {
    _responseRawStreamController.close();
    _responseMessagesStreamController.close();
    _errorStreamController.close();
    _serialPortStreamController.close();
  }

  // TO DO CANCEL STREAM??
  Stream<MSPDataHandler> responseStreamAs<MSPDataHandler>(int code) {
    Stream<MSPMessageResponse> stream = this.responseStream(code);

    StreamTransformer<MSPMessageResponse, MSPDataHandler> doubleTransformer =
        new StreamTransformer<MSPMessageResponse, MSPDataHandler>.fromHandlers(
            handleData: (data, EventSink sink) {
      var trans = this.transform(code, data);
      if (trans != null) {
        sink.add(trans);
      }
    });

    Stream<MSPDataHandler> dataHandler = stream.transform(doubleTransformer);
    return dataHandler;
  }

  Stream<MSPDataHandler> responseStreamsAs(Iterable<int> codes) {
    Iterable<Stream<MSPDataHandler>> streams =
        codes.map((e) => responseStreamAs(e));

    return StreamGroup.merge(streams);
  }

  int writeFunc(int code) {
    MSPMessageRequest request = MSPMessageRequest(code);
    return this.writeRequest(request);
  }

  int writeBuilder(MSPRequestBuilder builder) {
    MSPMessageRequest request = builder.toRequest();
    return this.writeRequest(request);
  }

  T? transform<T>(int code, MSPMessageResponse messageResponse) {
    return MSPDataClassTransformers.transform(code, messageResponse);
  }

  Stream<MSPMessageResponse> responseStream(int code) {
    if (!this.streamMaps.containsKey(code)) {
      // ignore: close_sinks
      var newStream = StreamController<MSPMessageResponse>.broadcast();
      this.streamMaps[code] = newStream;
    }

    return this.streamMaps[code]!.stream;
  }

  disconnect() {
    return _provider.disconnect();
  }

  void reconnect() {
    // return _provider.reconnect();
  }

  void flush() {
    return _provider.flush();
  }

  void drain() {
    return _provider.drain();
  }

  writeString(String data) {
    return _provider.writeString(data);
  }

  writeRequest(MSPMessageRequest request) {
    Uint8List data = request.packetData;
    return this.write(data.buffer.asUint8List().toList());
  }

  write(List<int> data) {
    return _provider.write(data);
  }

  void _gotData(List<int> data) {
    // responseRawSink.add(data);

    MSPMessageResponse respone = new MSPMessageResponse(payloadData: data);
    bool worked = respone.readData();
    if (!worked) {
      return;
    }

    int code = respone.function;

    if (this.streamMaps.containsKey(code)) {
      this.streamMaps[code]!.sink.add(respone);
    }

    responseMessagesSink.add(respone);
  }
}
