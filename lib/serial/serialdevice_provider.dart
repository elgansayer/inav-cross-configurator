import 'package:libserialport/libserialport.dart';

class SerialDeviceProvider {
  SerialDeviceProvider();
  SerialPort open(String portWanted) {
    SerialPort serialPort = SerialPort(portWanted);
    if (!serialPort.openReadWrite()) {
      print(SerialPort.lastError);
    }

    return serialPort;
  }
}

class MSPProvider {}
