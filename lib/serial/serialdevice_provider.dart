// import 'dart:async';
// import 'dart:typed_data';
// import 'package:inavconfiurator/msp/codes/api_version.dart';
// import 'package:inavconfiurator/msp/codes/fcvariant.dart';
// import 'package:inavconfiurator/msp/codes.dart';
// import 'package:inavconfiurator/msp/data_class_builders.dart';
// import 'package:inavconfiurator/msp/mspmessage.dart';
// import 'package:libserialport/libserialport.dart';

// class SerialDeviceProvider {
//   SerialDeviceProvider();

//   late Map<int, StreamController<MSPMessageResponse>> streamMaps = {};

//   late SerialPortReader _reader;
//   final _responseMessagesStreamController =
//       StreamController<MSPMessageResponse>.broadcast();

//   late SerialPort _serialPort;

//   StreamSink<MSPMessageResponse> get responseMessagesSink =>
//       _responseMessagesStreamController.sink;

//   Stream<MSPMessageResponse> get responseMessages =>
//       _responseMessagesStreamController.stream;

//   Stream<MSPMessageResponse> streams(int wanted) {
//     if (!this.streamMaps.containsKey(wanted)) {
//       // ignore: close_sinks
//       var newStream = StreamController<MSPMessageResponse>.broadcast();
//       this.streamMaps[wanted] = newStream;
//     }

//     return this.streamMaps[wanted]!.stream;
//   }

//   Future<MSPMessageResponse> response(Stream<MSPMessageResponse> stream) async {
//     var value;
//     await for (var data in stream) {
//       return data;
//     }
//     return value;
//   }

//   Future<T> responseAs<T>(int code) async {
//     Stream<MSPMessageResponse> stream = this.streams(code);
//     MSPMessageResponse data = await this.response(stream);
//     return MSPDataClassBuilders.get(code, data);
//   }

//   Future<T> writeWithResponseAs<T>(SerialPort serialPort, int code) async {
//     MSPMessageRequest request = MSPMessageRequest(code);
//     request.write(serialPort);

//     // Wait for response
//     return this.responseAs<T>(code);
//   }

//   Future<SerialPort?> open(String portWanted) async {
//     this._serialPort = SerialPort(portWanted);

//     this._closeMaps();

//     if (!this._serialPort.openReadWrite()) {
//       this._serialPort.close();
//       throw new Exception("Failed to open port for read/write operations");
//     }

//     // Setup reader
//     this._reader = SerialPortReader(this._serialPort);
//     this._reader.stream.listen(this.gotData);

//     MSPApiVersion apiVersion = await this.writeWithResponseAs<MSPApiVersion>(
//         this._serialPort, MSPCodes.mspApiVersion);

//     // Check we are version compatible?
//     if (apiVersion.apiVersionMajor < 2) {
//       this._serialPort.close();
//       throw new Exception("Failed version check. ${apiVersion.apiVersion}");
//     }

//     MSPFcVariant mspFcVariant = await this.writeWithResponseAs<MSPFcVariant>(
//         this._serialPort, MSPCodes.mspFcVariant);

//     // Check we are using INAV on the board
//     if (mspFcVariant.flightControllerIdentifier != "INAV") {
//       this._serialPort.close();
//       throw new Exception(
//           "Failed flight controller identification. ${mspFcVariant.flightControllerIdentifier}");
//     }

//     // Last error is never reset
//     // if (SerialPort.lastError!.message.isNotEmpty) {
//     //   serialPort.close();
//     //   throw new Exception(SerialPort.lastError);
//     // }

//     print(apiVersion.apiVersion);
//     print(mspFcVariant);

//     return this._serialPort;
//   }

//   void gotData(Uint8List event) {
//     MSPMessageResponse respone = new MSPMessageResponse(event);
//     var code = respone.function;

//     if (this.streamMaps.containsKey(code)) {
//       this.streamMaps[code]!.sink.add(respone);
//     }

//     responseMessagesSink.add(respone);
//   }

//   dispose() {
//     this._reader.close();
//     _responseMessagesStreamController.close();
//     this._closeMaps();
//     if (this._serialPort.isOpen) {
//       this._serialPort.close();
//     }
//   }

//   _closeMaps() {
//     this.streamMaps.forEach((key, value) {
//       this.streamMaps[key]!.close();
//     });
//     this.streamMaps.clear();
//   }
// }

// import 'dart:async';

// import 'package:inavconfiurator/serial/serialdevice_provider.dart';
// import 'package:inavconfiurator/serial/serialport_model.dart';
// import 'package:libserialport/libserialport.dart';

// class SerialDeviceRepository {
//   SerialDeviceRepository();

//   final _errorStreamController = StreamController<String>();

//   final SerialDeviceProvider _serialDevicesProvider = SerialDeviceProvider();
//   final _serialPortStreamController = StreamController<SerialPort?>.broadcast();

//   StreamSink<SerialPort?> get _serialPortDeviceSink =>
//       _serialPortStreamController.sink;

//   Stream<SerialPort?> get serialPortDevice =>
//       _serialPortStreamController.stream;

//   //
//   StreamSink<String> get _serialPortDeviceErrorSink =>
//       _errorStreamController.sink;

//   Stream<String> get serialPortDeviceError => _errorStreamController.stream;

//   Future<bool> connect(SerialPortInfo serialPortInfo) async {
//     // SerialPort? port =
//     try {
//       var port = await _serialDevicesProvider.open(serialPortInfo.name);
//       _serialPortDeviceSink.add(port);
//     } catch (e) {
//       _serialPortDeviceErrorSink.add(e.toString());
//     }

//     // return port != null;
//     return false;
//   }

//   dispose() {
//     _serialDevicesProvider.dispose();
//     _serialPortDeviceSink.close();
//     _serialPortDeviceErrorSink.close();
//     _serialPortStreamController.close();
//     _errorStreamController.close();
//   }
// }
