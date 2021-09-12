import 'dart:async';
import 'dart:typed_data';
import 'package:inavconfiurator/msp/codes/api_version.dart';
import 'package:inavconfiurator/msp/codes/fcvariant.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/data_transformers.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';
import 'package:libserialport/libserialport.dart';

enum SerialDeviceEventType { connected, disconnected }

class SerialDeviceEvent {
  final SerialPort serialPort;
  final SerialDeviceEventType type;

  SerialDeviceEvent(this.serialPort, this.type);
}

class SerialDeviceRepository {
  late StreamSubscription<Uint8List> _readerListener;

  // late Timer _heartBeatTimer;

  SerialDeviceRepository();

  late Map<int, StreamController<MSPMessageResponse>> streamMaps = {};

  final _errorStreamController = StreamController<String>.broadcast();
  late SerialPortReader _reader;
  final _responseMessagesStreamController =
      StreamController<MSPMessageResponse>.broadcast();

  late SerialPort _serialPort;
  final _serialPortStreamController =
      StreamController<SerialDeviceEvent>.broadcast();

  Stream<String> get serialPortDeviceError => _errorStreamController.stream;

  StreamSink<SerialDeviceEvent> get _serialPortDeviceSink =>
      _serialPortStreamController.sink;

  Stream<SerialDeviceEvent> get serialPortDevice =>
      _serialPortStreamController.stream;

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

  Future<T> write<T>(int code) async {
    if (!this._serialPort.isOpen) {
      throw new Exception("SerialPort is not open");
    }

    MSPMessageRequest request = MSPMessageRequest(code);
    request.write(this._serialPort);

    // Wait for response
    return this.responseAs<T>(code);
  }

  Future<T> writeWithResponseAs<T>(int code) async {
    if (!this._serialPort.isOpen) {
      throw new Exception("SerialPort is not open");
    }

    MSPMessageRequest request = MSPMessageRequest(code);
    request.write(this._serialPort);

    // Wait for response
    return this.responseAs<T>(code);
  }

  _checkApiVersion() async {
    print("Getting API versions");

    try {
      MSPApiVersion apiVersion =
          await this.writeWithResponseAs<MSPApiVersion>(MSPCodes.mspApiVersion);

      // Check we are version compatible?
      if (apiVersion.apiVersionMajor < 2) {
        this.closeDevice();
        throw new Exception("Failed version check. ${apiVersion.apiVersion}");
      }

      print("Detected API Version ${apiVersion.apiVersion}");
      return true;
    } catch (e) {
      throw new Exception("Failed to get API version");
    }
  }

  _checkFCFvarient() async {
    try {
      MSPFcVariant mspFcVariant =
          await this.writeWithResponseAs<MSPFcVariant>(MSPCodes.mspFcVariant);

      // Check we are using INAV on the board
      if (mspFcVariant.flightControllerIdentifier != "INAV") {
        this.closeDevice();
        throw new Exception(
            "Failed flight controller identification. ${mspFcVariant.flightControllerIdentifier}");
      }

      print(mspFcVariant);
      print("Detected Fc Variant $mspFcVariant");
      return true;
    } catch (e) {
      throw new Exception("Failed flight controller identification");
    }
  }

  Future<SerialPort?> connect(SerialPortInfo portcode) async {
    String portPath = portcode.name;
    this._serialPort = SerialPort(portPath);
    print("Opening $portPath");

    this._closeMaps();

    if (!this._serialPort.openReadWrite()) {
      String msg = "Failed to open port for read/write operations";
      this.closeDevice();
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
    final newEvent = new SerialDeviceEvent(
        this._serialPort, SerialDeviceEventType.connected);
    this._serialPortDeviceSink.add(newEvent);

    return this._serialPort;
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

  void disconnect() {
    this._readerListener.cancel();
    this.closeDevice();
    this._closeMaps();
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
