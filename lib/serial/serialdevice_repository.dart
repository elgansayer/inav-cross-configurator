import 'dart:async';
import 'package:async/async.dart';
import 'package:inavconfigurator/msp/codes.dart';
import 'package:inavconfigurator/msp/codes/api_version.dart';
import 'package:inavconfigurator/msp/codes/base_data_handler.dart';
import 'package:inavconfigurator/msp/codes/fcvariant.dart';
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
  late Map<int, StreamController<MSPMessageResponse>> streamMaps = {};

  final _errorStreamController = StreamController<String>.broadcast();
  final SerialDeviceProvider _provider = new SerialDeviceProvider();
  final _responseMessagesStreamController =
      StreamController<MSPMessageResponse>.broadcast();

  final _responseRawStreamController = StreamController<List<int>>.broadcast();
  final _serialPortStreamController =
      StreamController<SerialDeviceEvent>.broadcast();

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
    _provider.data.listen(this._gotData);
  }

  close() {
    _responseRawStreamController.close();
    _responseMessagesStreamController.close();
    _errorStreamController.close();
    _serialPortStreamController.close();
  }

  // TODO CANCEL STREAM??
  Stream<MSPDataHandler> responseStreamAs<MSPDataHandler>(int code) {
    // Stream<List<String>> ddd = CombineLatestStream.list<String>([
    //   Stream.fromIterable(['a']),
    //   Stream.fromIterable(['b']),
    //   Stream.fromIterable(['C', 'D'])
    // ]).asBroadcastStream();

    // StreamController<T> newStream = StreamController<T>();
    Stream<MSPMessageResponse> stream = this.responseStream(code);

    StreamTransformer<MSPMessageResponse, MSPDataHandler> doubleTransformer =
        new StreamTransformer<MSPMessageResponse, MSPDataHandler>.fromHandlers(
            handleData: (data, EventSink sink) {
      var trans = this.transform(code, data);
      sink.add(trans);
    });

    Stream<MSPDataHandler> ddd = stream.transform(doubleTransformer);
    return ddd;

    // stream.listen((event) async {
    //   MSPMessageResponse messageResponse = await this.response(stream);
    //   var response = this.transform(code, messageResponse);
    //   newStream.add(response);
    // });

    // return newStream.stream;
  }

  Stream<MSPDataHandler> responseStreamsAs(Iterable<int> codes) {
    Iterable<Stream<MSPDataHandler>> streams =
        codes.map((e) => responseStreamAs(e));

    return StreamGroup.merge(streams);
  }

  int writeFunc(int code, {int timeout = 10}) {
    MSPMessageRequest request = MSPMessageRequest(code);
    return this._provider.writeRequest(request);
    // return request.write(this._provider, timeout: timeout);
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

  void reconnect() {}

  void flush() {}

  void drain() {}

  writeString(String data) {
    return _provider.writeString(data);
  }

  void _gotData(List<int> data) {
    responseRawSink.add(data);

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
