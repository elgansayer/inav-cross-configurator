
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:libserialport/libserialport.dart';

// import 'msp/mspmessage.dart';

// void showPorts() {
//   print('Available ports:');
//   var i = 0;
//   for (final name in SerialPort.availablePorts) {
//     try {
//       final sp = SerialPort(name);
//       print('${++i}) $name');
//       print('\tDescription: ${sp.description}');
//       print('\tManufacturer: ${sp.manufacturer}');
//       print('\tSerial Number: ${sp.serialNumber}');
//       print('\tProduct ID: 0x${sp.productId!.toRadixString(16)}');
//       print('\tVendor ID: 0x${sp.vendorId!.toRadixString(16)}');
//       sp.dispose();
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// void sendMessage(port, code, Uint8List data) {
//   MSPMessage message = new MSPMessage(code, data);
//   var d = message.request();
//   port.write(d);
// }

// void openBoard() {
//   String portWanted = "/dev/ttyACM0";
//   for (var item in SerialPort.availablePorts) {
//     final sp = SerialPort(item);
//     if (sp.manufacturer == 'INAV') {
//       portWanted = sp.name.toString();
//     }
//   }
//   print("Using port $portWanted");
//   final port = SerialPort(portWanted);
//   if (!port.openReadWrite()) {
//     print(SerialPort.lastError);
//   }

//   sendMessage(port, 1, new Uint8List(0));

//   final reader = SerialPortReader(port);
//   reader.stream.listen((data) {
//     try {
//       print('received: $data');
//       print(ascii.decode(data));

//       MSPMessage msg = MSPMessage.fromUint8List(data);

//       print(ascii.decode(msg.payload.toList()));
//     } catch (e) {} finally {
//       port.close();
//       reader.close();
//       port.dispose();
//     }
//   });
// }
