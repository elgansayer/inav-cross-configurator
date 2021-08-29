import 'dart:convert';
import 'dart:typed_data';
import 'package:libserialport/libserialport.dart';

// https://github.com/iNavFlight/inav/wiki/MSP-V2

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
  late int function;
  // uint16 (little endian) payload size in bytes
  late int payloadSize;
  // n (up to 65535 bytes) payload
  late Uint8List payload;
  // uint8, (n= payload size), crc8_dvb_s2 checksum
  late int checksum;
  late int payloadLength = 0;
  // final Uint8List? data;
  late int msgLength;

  MSPMessage();

  // factory MSPMessage.fromString(String data) {
  //   return new MSPMessage(0, ascii.encode(data));
  // }

  // factory MSPMessage.requestfromUint8List(Uint8List data) {
  //   int rLen = data[6];
  //   int func = data[4];
  //   // int rChecksum = data[8 + tLen];
  //   List<int> rData = data.getRange(8, 8 + rLen).toList();
  //   Uint8List rPayload = new Uint8List.fromList(rData);

  //   return new MSPMessage(func, rPayload);
  // }

  factory MSPMessage.request(int function, Uint8List? payload) {
    return new MSPMessageRequest(function, payloadData: payload);
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

// class MSPMessageReader<T extends MSPDataHandler> extends MSPMessageResponse {
//   // MSPMessageReader(Uint8List payloadData) : super(payloadData) {
//   //   var d = MSPDataBuilders.classBuilder;
//   //   var dd = d[1];
//   //   if (dd != null) {
//   //     T ddd = dd();
//   //   }
//   // }

//   // Stream<T> readme<T>() {
//   //   final reader = SerialPortReader(serialPort);
//   //   reader.stream.listen((data) {
//   //     // T data;
//   //     // data.code = new T(data);

//   //     var d = MSPDataBuilders.classBuilder;
//   //     var dd = d[1];
//   //     T m ;
//   //     if (dd != null) {
//   //       m = dd(data);
//   //       if(m.)
//   //     }

//   //   });
//   // }

//   // T read(serialPort) {
//   //   final reader = SerialPortReader(serialPort);
//   //   reader.stream.listen((data) {
//   //     // T data;
//   //     // data.code = new T(data);

//   //     var d = MSPDataBuilders.classBuilder;
//   //     var dd = d[1];
//   //     if (dd != null) {
//   //       return dd(data);
//   //     }
//   //   });
//   // }
// }

class MSPMessageResponse extends MSPMessage {
  final Uint8List _payloadData;

  MSPMessageResponse(Uint8List payloadData) : _payloadData = payloadData {
    _readData();
  }

  _readData() {
    this.payloadLength = this._payloadData[6];
    this.function = this._payloadData[4];
    this.msgLength = this.payloadLength + MSPMessage.structLength;

    // int rChecksum = data[8 + tLen];
    List<int> rData =
        this._payloadData.getRange(8, 8 + this.payloadLength).toList();

    this.payload = new Uint8List.fromList(rData);
  }
}

class MSPMessageRequest extends MSPMessage {
  // Used to build the message
  late Uint8List _buffer;

  MSPMessageRequest(int code, {Uint8List? payloadData}) {
    if (payloadData != null) {
      this.payload = payloadData;
    } else {
      this.payload = Uint8List(MSPMessage.structLength);
    }

    this.function = code;
    this.payloadLength = this.payload.length > 0 ? this.payload.length : 0;
    this.msgLength = this.payloadLength + MSPMessage.structLength;
    this._buildRequest();
  }

  Uint8List _buildRequest() {
    // Send/Recieve buffer
    this._buffer = new Uint8List(this.msgLength);

    // Assign the bugger with the request header
    this.header = new RequestMessageHeader(this._buffer);

    // flag: reserved, set to 0
    this._buffer[3] = this.flag;
    this._buffer[4] = function & 0xFF; // code lower byte
    this._buffer[5] = (function & 0xFF00) >> 8; // code upper byte
    this._buffer[6] = payloadLength & 0xFF; // payloadLength lower byte
    this._buffer[7] = (payloadLength & 0xFF00) >> 8; // payloadLength upper byte

    this._addData();

    this._buffer[this.msgLength - 1] = this._checksum(this._buffer);

    return this._buffer;
  }

  _addData() {
    for (int ii = 0; ii < payloadLength; ii++) {
      this._buffer[8 + ii] = this._buffer.elementAt(ii);
    }
  }

  void write(SerialPort serialPort) {
    serialPort.write(this._buffer);
  }
}
