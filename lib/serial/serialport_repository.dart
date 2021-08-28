
import 'package:inavconfiurator/serial/serialport_model.dart';

import 'serialport_provider.dart';

class SerialPortRepository {
  final SerialPortProvider _serialPortsProvider = SerialPortProvider();
  List<SerialPortInfo> get ports => _serialPortsProvider.ports;
  SerialPortRepository();

}