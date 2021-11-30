import 'package:libserialport/libserialport.dart';

class SerialDevice {
  SerialDevice(this.name, this.serialPort);

  final String name;
  final SerialPort serialPort;
}
