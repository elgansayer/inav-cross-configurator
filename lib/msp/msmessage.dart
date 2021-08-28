import 'dart:convert';
import 'dart:typed_data';
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
