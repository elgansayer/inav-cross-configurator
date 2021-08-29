import 'dart:async';

import 'package:inavconfiurator/serial/serialdevice_provider.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';
import 'package:libserialport/libserialport.dart';

class SerialDeviceRepository {
  SerialDeviceRepository();

  final _errorStreamController = StreamController<String>();

  final SerialDeviceProvider _serialDevicesProvider = SerialDeviceProvider();
  final _serialPortStreamController = StreamController<SerialPort?>.broadcast();

  StreamSink<SerialPort?> get _serialPortDeviceSink =>
      _serialPortStreamController.sink;

  Stream<SerialPort?> get serialPortDevice =>
      _serialPortStreamController.stream;

  //
  StreamSink<String> get _serialPortDeviceErrorSink =>
      _errorStreamController.sink;

  Stream<String> get serialPortDeviceError => _errorStreamController.stream;

  Future<bool> connect(SerialPortInfo serialPortInfo) async {
    // SerialPort? port =
    try {
      await _serialDevicesProvider.open(serialPortInfo.name);
    } catch (e) {
      _serialPortDeviceErrorSink.add(e.toString());
    }

    // _serialPortDeviceSink.add(port);

    // if (port == null) {
    //   var error = SerialPort.lastError;
    //   if (error != null) {
    //     _serialPortDeviceErrorSink.add(error.message);
    //   }
    // }

    // return port != null;
    return false;
  }

  dispose() {
    _serialPortDeviceSink.close();
    _serialPortDeviceErrorSink.close();
    _serialPortStreamController.close();
    _errorStreamController.close();
  }
}
