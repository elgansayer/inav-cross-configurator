
import 'package:libserialport/libserialport.dart';

class SerialDevice {
  final String name;
  final SerialPort serialPort;

  SerialDevice(this.name, this.serialPort);
}
