import 'dart:async';

import 'package:inavconfiurator/serial/serialdevice_provider.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';
import 'package:libserialport/libserialport.dart';

class SerialDeviceRepository {
  SerialDeviceRepository();
  final SerialDeviceProvider _serialDevicesProvider = SerialDeviceProvider();

  final _serialPortStreamController = StreamController<SerialPort?>();
  final _errorStreamController = StreamController<String>();

  StreamSink<SerialPort?> get _serialPortDeviceSink =>
      _serialPortStreamController.sink;
  Stream<SerialPort?> get serialPortDevice =>
      _serialPortStreamController.stream;

  //
  StreamSink<String> get _serialPortDeviceErrorSink =>
      _errorStreamController.sink;
  Stream<String> get serialPortDeviceError =>
      _errorStreamController.stream;

  bool connect(SerialPortInfo serialPortInfo) {
    SerialPort? port = _serialDevicesProvider.open(serialPortInfo.name);
    _serialPortDeviceSink.add(port);

    if (port == null) {
      var error = SerialPort.lastError;
      if (error != null) {
        _serialPortDeviceErrorSink.add(error.message);
      }
    }

    return port != null;
  }

  dispose() {
    _serialPortStreamController.close();
    _errorStreamController.close();
  }
}
