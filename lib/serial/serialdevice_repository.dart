import 'package:inavconfiurator/serial/serialdevice_provider.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';
import 'package:libserialport/libserialport.dart';

class SerialDeviceRepository {
  SerialDeviceRepository();

  late SerialPort _port;
  final SerialDeviceProvider _serialDevicesProvider = SerialDeviceProvider();

  SerialPort get serialDevice => this._port;

  bool connect(SerialPortInfo serialPortInfo) {
    this._port = _serialDevicesProvider.open(serialPortInfo.name);
    return true;
  }
}
