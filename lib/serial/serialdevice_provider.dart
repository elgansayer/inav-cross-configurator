import 'dart:async';
import 'dart:typed_data';
import 'package:inavconfiurator/msp/builders/api_version.dart';
import 'package:inavconfiurator/msp/builders/fcvariant.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/data_class_builders.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';
import 'package:libserialport/libserialport.dart';

class SerialDeviceProvider {
  SerialDeviceProvider();
  late SerialPortReader _reader;
  Map<int, StreamController<MSPMessageResponse>> maps = {};

  final _responseMessagesStreamController =
      StreamController<MSPMessageResponse>.broadcast();

  StreamSink<MSPMessageResponse> get responseMessagesSink =>
      _responseMessagesStreamController.sink;

  Stream<MSPMessageResponse> get responseMessages =>
      _responseMessagesStreamController.stream;

  Stream<MSPMessageResponse> streams(int wanted) {
    if (!maps.containsKey(wanted)) {
      // ignore: close_sinks
      var newStream = StreamController<MSPMessageResponse>.broadcast();
      maps[wanted] = newStream;
    }

    return maps[wanted]!.stream;
  }

  Future<MSPMessageResponse> response(Stream<MSPMessageResponse> stream) async {
    var value;
    await for (var data in stream) {
      return data;
    }
    return value;
  }

  Future<T> responseAs<T>(int code) async {
    Stream<MSPMessageResponse> stream = this.streams(code);
    MSPMessageResponse data = await this.response(stream);
    return MSPDataClassBuilders.get(code, data);
  }

  Future<T> writeWithResponseAs<T>(SerialPort serialPort, int code) async {
    MSPMessageRequest request = MSPMessageRequest(code);
    request.write(serialPort);

    // Wait for response
    return this.responseAs<T>(code);
  }

  Future<SerialPort?> open(String portWanted) async {
    SerialPort serialPort = SerialPort(portWanted);

    this._closeMaps();

    if (!serialPort.openReadWrite()) {
      serialPort.close();
      throw new Exception("Failed to open port for read/write operations");
    }

    // Setup reader
    this._reader = SerialPortReader(serialPort);
    this._reader.stream.listen(this.gotData);

    MSPApiVersion apiVersion = await this
        .writeWithResponseAs<MSPApiVersion>(serialPort, MSPCodes.mspApiVersion);

    print(apiVersion.apiVersion);

    // Check we are version compatible?
    if (apiVersion.apiVersionMajor < 2) {
      serialPort.close();
      throw new Exception("Failed version check. ${apiVersion.apiVersion}");
    }

    MSPFcVariant mspFcVariant = await this
        .writeWithResponseAs<MSPFcVariant>(serialPort, MSPCodes.mspFcVariant);

    // Check we are using INAV on the board
    if (mspFcVariant.flightControllerIdentifier != "INAV") {
      serialPort.close();
      throw new Exception(
          "Failed flight controller identification. ${mspFcVariant.flightControllerIdentifier}");
    }

    // Last error is never reset
    // if (SerialPort.lastError!.message.isNotEmpty) {
    //   serialPort.close();
    //   throw new Exception(SerialPort.lastError);
    // }

    print(apiVersion.apiVersion);
    print(mspFcVariant);

    return serialPort;
  }

  void gotData(Uint8List event) {
    MSPMessageResponse respone = new MSPMessageResponse(event);
    var code = respone.function;

    if (maps.containsKey(code)) {
      maps[code]!.sink.add(respone);
    }

    responseMessagesSink.add(respone);
  }

  dispose() {
    this._reader.close();
    _responseMessagesStreamController.close();
    this._closeMaps();
  }

  _closeMaps() {
    this.maps.forEach((key, value) {
      this.maps[key]!.close();
    });
    this.maps.clear();
  }
}

class MSPProvider {}
