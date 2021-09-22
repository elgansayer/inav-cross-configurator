import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:inavconfiurator/msp/codes/api_version.dart';
import 'package:inavconfiurator/msp/codes/fcvariant.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/data_transformers.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';
import 'package:inavconfiurator/serial/serialport_provider.dart';
import 'package:libserialport/libserialport.dart';

enum SerialDeviceEventType { connected, connecting, disconnected }

class SerialDeviceEvent {
  final SerialPort serialPort;
  final SerialDeviceEventType type;

  SerialDeviceEvent(this.serialPort, this.type);
}

class SerialDeviceRepository {
  late StreamSubscription<Uint8List> _readerListener;

  // Last connected
  late SerialPortInfo _serialPortInfo;

  // late Timer _heartBeatTimer;

  SerialDeviceRepository();

  late Map<int, StreamController<MSPMessageResponse>> streamMaps = {};

  final _errorStreamController = StreamController<String>.broadcast();
  late SerialPortReader _reader;
  final _responseMessagesStreamController =
      StreamController<MSPMessageResponse>.broadcast();
  final _responseRawStreamController = StreamController<Uint8List>.broadcast();

  late SerialPort _serialPort;
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

  Stream<MSPMessageResponse> responseStreams(int code) {
    if (!this.streamMaps.containsKey(code)) {
      // ignore: close_sinks
      var newStream = StreamController<MSPMessageResponse>.broadcast();
      this.streamMaps[code] = newStream;
    }

    return this.streamMaps[code]!.stream;
  }

  Future<MSPMessageResponse> response(Stream<MSPMessageResponse> stream) async {
    Stream<MSPMessageResponse> newStream = stream.timeout(Duration(seconds: 5));

    var value;
    await for (var data in newStream) {
      return data;
    }

    return value;
  }

  Future<T> responseAs<T>(int code) async {
    Stream<MSPMessageResponse> stream = this.responseStreams(code);
    MSPMessageResponse messageResponse = await this.response(stream);
    return this.transform(code, messageResponse);
  }

  T? transform<T>(int code, MSPMessageResponse messageResponse) {
    return MSPDataClassTransformers.transform(code, messageResponse);
  }

  int writeFunc(int code) {
    MSPMessageRequest request = MSPMessageRequest(code);
    return request.write(this._serialPort);
  }

  int writeString(String str) {
    final Uint8List bytes = ascii.encode(str);
    return this._serialPort.write(bytes);
  }

  int writeBytes(Uint8List bytes) {
    return this._serialPort.write(bytes);
  }

  Future<T?> writeFuncWithResponseAs<T>(int code) async {
    if (!this._serialPort.isOpen) {
      throw new Exception("SerialPort is not open");
    }
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

    // Inform app we are connecting
    final newConnectingEvent = new SerialDeviceEvent(
        this._serialPort, SerialDeviceEventType.connecting);
    this._serialPortDeviceSink.add(newConnectingEvent);

    if (!this._serialPort.openReadWrite()) {
      String msg = "Failed to open port for read/write operations";
      this.disconnect(skipReader: true);
      throw new Exception(msg);
    }

    // Setup reader
    this._reader = SerialPortReader(this._serialPort);
    this._readerListener = this._reader.stream.listen(this._gotData);

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

  void _gotData(Uint8List event) {
    responseRawSink.add(event);

    // try {
    MSPMessageResponse respone = new MSPMessageResponse(event);
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
      this._serialPort.close();
    }

    // this._heartBeatTimer.cancel();
    this._serialPort.dispose();
  }
}
