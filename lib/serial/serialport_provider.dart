import 'package:libserialport/libserialport.dart';

import 'serialport_model.dart';

class SerialPortProvider {
  List<SerialPortInfo> get ports {
    List<SerialPortInfo> serialPorts =
        new List<SerialPortInfo>.empty(growable: true);

    for (var name in SerialPort.availablePorts) {
      {
        final sp = SerialPort(name);
        try {
          final int address = (sp.address is Exception) ? -1 : sp.address;

          final String description =
              (sp.description is Exception) ? "" : sp.description ?? "";

          final String manufacturer =
              (sp.manufacturer is Exception) ? "" : sp.manufacturer ?? "";

          final String serialNumber =
              (sp.serialNumber is Exception) ? "" : sp.serialNumber ?? "";

          SerialPortInfo serialPortInfo = new SerialPortInfo(
              name, address, description, manufacturer, serialNumber);

          serialPorts.add(serialPortInfo);
        } catch (e) {
          print(e);
        } finally {
          sp.dispose();
        }
      }
    }

    return serialPorts;
  }
}
