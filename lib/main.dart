import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/components/bloc/errorbanner_bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:libserialport/libserialport.dart';

import 'app/bloc/app_bloc.dart';
import 'components/bloc/errormessage_repository.dart';
import 'devices/devices_page.dart';
import 'home/home_page.dart';
// https://github.com/iNavFlight/inav/wiki/MSP-V2

void main() {
  runApp(
    MultiRepositoryProvider(
      // create: (_) => SerialDeviceRepository(),
      providers: [
        RepositoryProvider<SerialDeviceRepository>(
            create: (_) => SerialDeviceRepository()),
        RepositoryProvider<ErrorMessageRepository>(
            create: (_) => ErrorMessageRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              serialDeviceRepository:
                  RepositoryProvider.of<SerialDeviceRepository>(context),
            ),
          ),
          BlocProvider(
              create: (context) => ErrorBannerBloc(
                    errorMessageRepository:
                        RepositoryProvider.of<ErrorMessageRepository>(context),
                  ))
        ],
        child: MyApp(),
      ),
    ),
  );
}

abstract class HeaderMessageTypes {
  // Can be sent by Master
  // Must be processed by Slave
  static String request = '<';

  // Only sent in response to a request
  // Can be sent by Slave annd processed by Master
  static String response = '>';

  // Response to receipt of data that cannot be processed
  // (corrupt checksum, unknown function, message type that cannot be processed)
  static String error = '!';
}

class HeaderProtocol {
  static String version1 = 'M';
  // 'X' in place of v1 'M'
  static String version2 = 'X';
}

class MessageHeader {
  // Same lead-in as V1
  final String lead = '\$';
  // 'X' in place of v1 'M'
  final String protocol = 'X';
  // '<' / '>' / '!'
  final String messageType;

  MessageHeader(this.messageType);

  // Uint8List get() {
  //   return ascii.encode("${this.lead}${this.protocol}${this.messageType}");
  // }

  // Works out which message header this is
  // from the data
  factory MessageHeader.create(Uint8List data) {
    String type = ascii.decode([data.elementAt(2)]);

    if (type == '<') {
      return MessageHeader.response();
    }

    if (type == '>') {
      return MessageHeader.request(data);
    }

    return MessageHeader.error();
  }

  factory MessageHeader.error() {
    throw new Exception();
  }

  factory MessageHeader.request(Uint8List buffer) {
    return new RequestMessageHeader(buffer);
  }

  factory MessageHeader.response() {
    return new ResponseMessageHeader();
  }
}

class RequestMessageHeader extends MessageHeader {
  RequestMessageHeader(Uint8List buffer) : super(HeaderMessageTypes.request) {
    Uint8List headerLst =
        ascii.encode("${this.lead}${this.protocol}${this.messageType}");

    for (var i = 0; i < headerLst.length; i++) {
      buffer[i] = headerLst[i];
    }
  }
}

class ResponseMessageHeader extends MessageHeader {
  ResponseMessageHeader() : super(HeaderMessageTypes.response);
}

// Message structure
//MSP V2 Message structure
class MSPMessage {
  late MessageHeader header;
  // uint8, flag, usage to be defined (set to zero)
  final int flag = 0;
  // Length of structure
  static int structLength = 9;
  // uint16 (little endian). 0 - 255 is the same function as V1 for backwards compatibility
  final int function;
  // uint16 (little endian) payload size in bytes
  late int payloadSize;
  // n (up to 65535 bytes) payload
  final Uint8List payload;
  // uint8, (n= payload size), crc8_dvb_s2 checksum
  late int checksum;
  late int payloadLength = 0;
  // final Uint8List? data;
  late int msgLength;

  MSPMessage(this.function, this.payload) {
    this.payloadLength = this.payload.length > 0 ? this.payload.length : 0;

    this.msgLength = this.payloadLength + MSPMessage.structLength;
  }

  factory MSPMessage.fromString(String data) {
    return new MSPMessage(0, ascii.encode(data));
  }

  factory MSPMessage.fromUint8List(Uint8List data) {
    int rLen = data[6];
    int func = data[4];
    // int rChecksum = data[8 + tLen];
    List<int> rData = data.getRange(8, 8 + rLen).toList();
    Uint8List rPayload = new Uint8List.fromList(rData);

    return new MSPMessage(func, rPayload);
  }

  Uint8List request() {
    // Send/Recieve buffer
    Uint8List buffer = new Uint8List(this.msgLength);

    // Assign the bugger with the request header
    this.header = new RequestMessageHeader(buffer);

    // flag: reserved, set to 0
    buffer[3] = this.flag;
    buffer[4] = function & 0xFF; // code lower byte
    buffer[5] = (function & 0xFF00) >> 8; // code upper byte
    buffer[6] = payloadLength & 0xFF; // payloadLength lower byte
    buffer[7] = (payloadLength & 0xFF00) >> 8; // payloadLength upper byte

    this._addData(buffer);

    buffer[this.msgLength - 1] = this._checksum(buffer);

    return buffer;
  }

  _addData(Uint8List buffer) {
    for (int ii = 0; ii < payloadLength; ii++) {
      buffer[8 + ii] = this.payload.elementAt(ii);
    }
  }

  _checksum(Uint8List buffer) {
    int tempChecksum = 0;
    for (int ii = 3; ii < this.msgLength - 1; ii++) {
      tempChecksum = this._crc8DVBS2(tempChecksum, buffer[ii]);
    }
    return tempChecksum;
  }

  int _crc8DVBS2(int crc, int ch) {
    crc ^= ch;
    for (var ii = 0; ii < 8; ++ii) {
      var vasl = crc & 0x80;
      if (vasl > 0) {
        crc = ((crc << 1) & 0xFF) ^ 0xD5;
      } else {
        crc = (crc << 1) & 0xFF;
      }
    }

    return crc;
  }
}

void showPorts() {
  print('Available ports:');
  var i = 0;
  for (final name in SerialPort.availablePorts) {
    try {
      final sp = SerialPort(name);
      print('${++i}) $name');
      print('\tDescription: ${sp.description}');
      print('\tManufacturer: ${sp.manufacturer}');
      print('\tSerial Number: ${sp.serialNumber}');
      print('\tProduct ID: 0x${sp.productId!.toRadixString(16)}');
      print('\tVendor ID: 0x${sp.vendorId!.toRadixString(16)}');
      sp.dispose();
    } catch (e) {
      print(e);
    }
  }
}

void sendMessage(port, code, Uint8List data) {
  MSPMessage message = new MSPMessage(code, data);
  var d = message.request();
  port.write(d);
}

void openBoard() {
  String portWanted = "/dev/ttyACM0";
  for (var item in SerialPort.availablePorts) {
    final sp = SerialPort(item);
    if (sp.manufacturer == 'INAV') {
      portWanted = sp.name.toString();
    }
  }
  print("Using port $portWanted");
  final port = SerialPort(portWanted);
  if (!port.openReadWrite()) {
    print(SerialPort.lastError);
  }

  sendMessage(port, 1, new Uint8List(0));

  final reader = SerialPortReader(port);
  reader.stream.listen((data) {
    try {
      print('received: $data');
      print(ascii.decode(data));

      MSPMessage msg = MSPMessage.fromUint8List(data);

      print(ascii.decode(msg.payload.toList()));
    } catch (e) {} finally {
      port.close();
      reader.close();
      port.dispose();
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INav Configurator',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: BlocBuilder<AppBloc, AppState>(
        builder: (BuildContext context, AppState state) {
          switch (state.appPage) {
            case AppPage.devices:
              return _devicesPageView();
            case AppPage.home:
              return _homeView();
            default:
              return _homeView();
          }
        },
      ),
    );
  }

  _homeView() {
    return HomePage();
  }

  _devicesPageView() {
    return DevicesPage();
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     // showPorts();
//     openBoard();

//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
