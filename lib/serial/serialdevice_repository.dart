import 'dart:async';
import 'package:async/async.dart';
import 'package:inavconfigurator/msp/codes/base_data_handler.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:libserialport/libserialport.dart';

import '../msp/codes.dart';
import '../msp/codes/api_version.dart';
import '../msp/codes/fcvariant.dart';
import '../msp/data_transformers.dart';
import '../msp/msp_message.dart';
import 'serialport_model.dart';
import 'serialport_provider.dart';

enum SerialDeviceEventType { connected, connecting, disconnected }

class SerialDeviceEvent {
  SerialDeviceEvent(this.serialPort, this.type);

  final SerialPort serialPort;
  final SerialDeviceEventType type;
}

class SerialDeviceRepository {
  // late Timer _heartBeatTimer;

  SerialDeviceRepository();

  late Map<int, StreamController<MSPMessageResponse>> streamMaps = {};

  final _errorStreamController = StreamController<String>.broadcast();
  late SerialPortReader _reader;
  late StreamSubscription<Uint8List> _readerListener;
  final _responseMessagesStreamController =
      StreamController<MSPMessageResponse>.broadcast();

  final _responseRawStreamController = StreamController<Uint8List>.broadcast();
  late SerialPort _serialPort;
  // Last connected
  late SerialPortInfo _serialPortInfo;

  final _serialPortStreamController =
      StreamController<SerialDeviceEvent>.broadcast();

  Stream<String> get serialPortDeviceError => _errorStreamController.stream;

  StreamSink<SerialDeviceEvent> get _serialPortDeviceSink =>
      _serialPortStreamController.sink;

  Stream<SerialDeviceEvent> get serialPortDevice =>
      _serialPortStreamController.stream;

  StreamSink<Uint8List> get responseRawSink =>
      _responseRawStreamController.sink;

  Stream<Uint8List> get responseRaw => _responseRawStreamController.stream;

  StreamSink<MSPMessageResponse> get responseMessagesSink =>
      _responseMessagesStreamController.sink;

  Stream<MSPMessageResponse> get responseMessages =>
      _responseMessagesStreamController.stream;

  Stream<MSPMessageResponse> responseStream(int code) {
    if (!this.streamMaps.containsKey(code)) {
      // ignore: close_sinks
      var newStream = StreamController<MSPMessageResponse>.broadcast();
      this.streamMaps[code] = newStream;
    }

    return this.streamMaps[code]!.stream;
  }

  Stream<MSPDataHandler> responseStreamsAs(Iterable<int> codes) {
    Iterable<Stream<MSPDataHandler>> streams =
        codes.map((e) => responseStreamAs(e));

    return StreamGroup.merge(streams);
  }

  Stream<MSPMessageResponse> responseStreams(Iterable<int> codes) {
    Iterable<Stream<MSPMessageResponse>> streams =
        codes.map((e) => responseStream(e));
    return StreamGroup.merge(streams);
    // Stream<MSPMessageResponse> s3 = StreamGroup.merge(streams);
    // StreamZip<MSPMessageResponse> to = StreamZip(streams);
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

  Future<T> responseAs<T>(int code) async {
    Stream<MSPMessageResponse> stream = this.responseStream(code);
    MSPMessageResponse messageResponse = await this.response(stream);
    return this.transform(code, messageResponse);
  }

  T? transform<T>(int code, MSPMessageResponse messageResponse) {
    return MSPDataClassTransformers.transform(code, messageResponse);
  }

  int writeFunc(int code, {int timeout = 10}) {
    MSPMessageRequest request = MSPMessageRequest(code);
    return request.write(this._serialPort, timeout: timeout);
  }

  int writeString(String str, {int timeout = 10}) {
    final Uint8List bytes = ascii.encode(str);
    return this._serialPort.write(bytes, timeout: timeout);
  }

  int writeBytes(Uint8List bytes, {int timeout = 10}) {
    return this._serialPort.write(bytes, timeout: timeout);
  }

  Future<T?> writeFuncWithResponseAs<T>(int code) async {
    int written = this.writeFunc(code);
    if (written <= 0) {
      return null;
    }

    // Wait for response
    return this.responseAs<T>(code);
  }

  _checkApiVersion() async {
    print("Getting API versions");

    try {
      MSPApiVersion? apiVersion = await this
          .writeFuncWithResponseAs<MSPApiVersion>(MSPCodes.mspApiVersion);

      // Check we are version compatible?
      if (apiVersion == null || apiVersion.apiVersionMajor < 2) {
        this.closeDevice();
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
        this.closeDevice();
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

  Future<bool> connect(SerialPortInfo serialPortInfo) async {
    String portPath = serialPortInfo.name;
    this._serialPortInfo = serialPortInfo;
    this._serialPort = SerialPort(portPath);
    print("Opening $portPath");

    if (this._serialPort.isOpen) {
      String msg = "Device already open";
      this.disconnect(skipReader: true);
      throw new Exception(msg);
    }

// CURRENT=MSP_ALTITUDE
// ser.baudrate=115200
// ser.bytesize=serial.EIGHTBITS
// ser.parity=serial.PARITY_NONE
// serial.stopbits=serial.STOPBITS_ONE
// ser.timeout=0
// ser.xonxoff=False
// ser.rtscts=False
// ser.dsrdtr=False
    // this._serialPort.config.
    // this._serialPort.config.stopBits = 1;
    // this._serialPort.config.parity = 1;
    // this._serialPort.config.parity = 1;

    // Inform app we are connecting
    final newConnectingEvent = new SerialDeviceEvent(
        this._serialPort, SerialDeviceEventType.connecting);
    this._serialPortDeviceSink.add(newConnectingEvent);

    if (!this._serialPort.openReadWrite()) {
      String msg = "Failed to open port for read/write operations";
      this.disconnect(skipReader: true);
      throw new Exception(msg);
    }

    // You should always set baud rate, data bits, parity and stop bits.

    var config = this._serialPort.config;
    config.baudRate = 115200;
    config.rts = SerialPortRts.off;
    config.cts = SerialPortCts.ignore;
    config.xonXoff = SerialPortXonXoff.disabled;
    config.setFlowControl(SerialPortFlowControl.rtsCts);

    // config.parity = SerialPortParity.none;
    // config.bits = 16;
    // config.stopBits = 1;
    this._serialPort.config = config;

    // var config = this._serialPort.config;
    // config.baudRate = 115200;
    // config.parity = SerialPortParity.none;
    // config.bits = 16;
    // config.stopBits = 1;
    // this._serialPort.config = config;

    // this._serialPort.config.stopBits = 1;
    // this._serialPort.config.bits = 8;
    // this._serialPort.config.parity = SerialPortParity.none;
    // this._serialPort.config.setFlowControl(SerialPortFlowControl.none);

    // SerialPortEvent <_--???
    // this._serialPort.config.xonXoff = SerialPortXonXoff.disabled;
    // this._serialPort.config.rts = SerialPortRts.off;
    // this._serialPort.config.dsr = SerialPortDsr.ignore;
    // this._serialPort.config.dtr = SerialPortDtr.off;

    print(this._serialPort.config.baudRate);

    // Setup reader
    final timeout = const Duration(seconds: 10).inMilliseconds;
    this._reader = SerialPortReader(this._serialPort, timeout: timeout);
    this._readerListener = this._reader.stream.listen(this._gotData);

    _reader.stream.handleError((onError) {
      print(
          "ON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERRORON ERROR $onError");
    });

    await this._checkApiVersion();
    await this._checkFCFvarient();

    // Start a heartbeat to track disconnecting
    // this._startHeartBeat();

    // Notify app of connection
    final newConnectedEvent = new SerialDeviceEvent(
        this._serialPort, SerialDeviceEventType.connected);
    this._serialPortDeviceSink.add(newConnectedEvent);

    return true;
  }

  // Currently cannot tell when device disconnected
  // void _startHeartBeat() {
  //   this._heartBeatTimer =
  //       new Timer.periodic(new Duration(seconds: 1), (timer) {
  //     // Stays open even when device disconnects
  //     // T ODO: Find a new way? write?
  //     if (this._serialPort.isOpen) {
  //       return;
  //     }

  //     final newEvent = new SerialDeviceEvent(
  //         this._serialPort, SerialDeviceEventType.disconnected);

  //     this._serialPortDeviceSink.add(newEvent);
  //     timer.cancel();
  //   });
  // }

  void _gotData(Uint8List data) {
    responseRawSink.add(data);

    print("_reader.stream ${SerialPort.lastError}");

    // try {
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
    // } catch (e) {
    //   // debugPrint(e.toString());
    // }
  }

  close() {
    this.disconnect();

    _responseRawStreamController.close();
    _errorStreamController.close();
    _serialPortStreamController.close();
    _responseMessagesStreamController.close();
  }

  _closeMaps() {
    this.streamMaps.forEach((key, value) {
      this.streamMaps[key]!.close();
    });
    this.streamMaps.clear();
  }

  void disconnect({bool skipReader = false}) {
    if (!skipReader) {
      this._readerListener.cancel();
    }
    this.closeDevice();
    this._closeMaps();
  }

  void flush() {
    return this._serialPort.flush();
  }

  void drain() {
    return this._serialPort.drain();
  }

  void reconnect() async {
    final serialPortInfo = this._serialPortInfo;

    // Close everything!
    this.disconnect();

    Completer<SerialPortInfo> completer = new Completer<SerialPortInfo>();
    SerialPortProvider serialPortProvider = new SerialPortProvider();

    var duration = new Duration(seconds: 1);
    Timer.periodic(duration, (timer) async {
      var allPosrts = serialPortProvider.ports;

      // Avoid exceptions
      SerialPortInfo portAvilable = allPosrts.firstWhere(
          (element) => element.serialNumber == serialPortInfo.serialNumber,
          orElse: () {
        return new SerialPortInfo.empty();
      });

      // An empty SerialPortInfo has an address of -1
      if (portAvilable.address != -1) {
        timer.cancel();
        completer.complete(portAvilable);
      }
    });

    // Wait for confirmation the port is back up!
    // but is it? We kinda need tow ait for it to init too
    var portSelected = await completer.future;
    await Future.delayed(Duration(seconds: 1));

    // Wait a few more seconds and try to connect
    var connectDuration = new Duration(seconds: 1);
    Timer.periodic(connectDuration, (Timer conTimer) async {
      try {
        var didConnect = await this.connect(portSelected);
        if (didConnect) {
          conTimer.cancel();
        }
      } catch (e) {}
    });
  }

  void closeDevice() {
    if (this._serialPort.isOpen) {
      this._reader.close();
      this._serialPort.drain();
      this._serialPort.flush();
      this._serialPort.close();
    }

    // this._heartBeatTimer.cancel();
    this._serialPort.dispose();
  }
}
