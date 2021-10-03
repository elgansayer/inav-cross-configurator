import 'dart:convert';
import 'dart:typed_data';
import 'package:libserialport/libserialport.dart';

// https://github.com/iNavFlight/inav/wiki/MSP-V2

abstract class HeaderMessageTypes {
  // Response to receipt of data that cannot be processed
  // (corrupt checksum, unknown function, message type that cannot be processed)
  static String error = '!';

  // Can be sent by Master
  // Must be processed by Slave
  static String request = '<';

  // Only sent in response to a request
  // Can be sent by Slave annd processed by Master
  static String response = '>';
}

class HeaderProtocol {
  static String version1 = 'M';
  // 'X' in place of v1 'M'
  static String version2 = 'X';
}

class MessageHeader {
  MessageHeader(this.messageType);

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

  // Same lead-in as V1 \$
  final String lead = '\$';

  // '<' / '>' / '!'
  final String messageType;

  // 'X' in place of v1 'M'
  final String protocol = 'X';
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
  MSPMessage();

  factory MSPMessage.request(int function, Uint8List? payload) {
    return new MSPMessageRequest(function, payloadData: payload);
  }

  // Length of structure
  static int structLength = 9;

  // uint8, (n= payload size), crc8_dvb_s2 checksum
  late int checksum;

  // uint8, flag, usage to be defined (set to zero)
  final int flag = 0;

  // uint16 (little endian). 0 - 255 is the same function as V1 for backwards compatibility
  late int function;

  late MessageHeader header;
  // final Uint8List? data;
  late int msgLength;

  // n (up to 65535 bytes) payload
  late ByteData payload;

  late int payloadLength = 0;
  // uint16 (little endian) payload size in bytes
  late int payloadSize;

  // Offset in payload buffer for flag
  int get _flagOffset => 3;

  // Offset in payload buffer for code or function id
  int get _functionLowOffset => 4;

  // Code upper byte offset
  int get __functionHighOffset => 5;

  // Offset in payload buffer for length of payload
  int get _payloadLengthLowOffset => 6;

  // Offset for
  int get _payloadLengthHighOffset => 7;

  // Offset in payload buffer where data starts
  int get _dataStartOffset => 8;

  late String error;

  _checksum(Uint8List buffer) {
    int tempChecksum = 0;
    for (int ii = 3; ii < this.msgLength - 1; ii++) {
      // tempChecksum = this._crc8DVBS2(tempChecksum, buffer[ii]);
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

class MSPMessageResponse extends MSPMessage {
  final Uint8List _packetResponse;

  MSPMessageResponse({required Uint8List packetResponse})
      : this._packetResponse = packetResponse {
    this._packetData = new ByteData.view(packetResponse.buffer);
    print(packetResponse);
    print(this._packetData);
  }

  late ByteData _packetData;

  bool readData() {
    int packetLength = this._packetData.lengthInBytes;

    if (packetLength <= this._payloadLengthLowOffset) {
      this.error = ("Packet error: Dropping packet of length $packetLength");
      return false;
    }

    Uint8List packetResponseData = this._packetResponse;

    // this.payloadLength -> message_length_expected
    this.payloadLength =
        packetResponseData.elementAt(this._payloadLengthLowOffset);
    this.payloadLength |=
        packetResponseData.elementAt(this._payloadLengthHighOffset) << 8;

    var message_length_expected = this.payloadLength;

    int recievedChecksum = packetResponseData.last;

    this.function = packetResponseData.elementAt(this._functionLowOffset);
    this.function |=
        packetResponseData.elementAt(this.__functionHighOffset) << 8;

    this.msgLength = packetLength;
    // this.checksum = _checksum(byteData);

// 0
//219
//163
//170
//29
// 175
    this.checksum = 0;
    this.checksum = this._crc8DVBS2(this.checksum, 0); // flag
    this.checksum = this._crc8DVBS2(this.checksum, this.function & 0xFF);
    this.checksum =
        this._crc8DVBS2(this.checksum, (this.function & 0xFF00) >> 8);

    this.checksum =
        this._crc8DVBS2(this.checksum, message_length_expected & 0xFF);
    this.checksum =
        this._crc8DVBS2(this.checksum, (message_length_expected & 0xFF00) >> 8);

    // for (var ii = this._dataStartOffset;
    //     ii < (this._dataStartOffset + this.payloadLength);
    //     ii++) {
    //   this.checksum = this._crc8DVBS2(this.checksum, byteData[ii]);
    // }

    // var rangeEnd = (this._dataStartOffset + this.payloadLength);

    var rangeData = packetResponseData
        .getRange(
            this._dataStartOffset, this._dataStartOffset + this.payloadLength)
        .toList();

    this.payload = new ByteData.view(Uint8List.fromList(rangeData).buffer);

    // var payloadData = byteData.getRange(this._dataStartOffset, rangeEnd);

    for (var index = 0; index < this.payload.lengthInBytes; index++) {
      // payload.getInt8(byteOffset)
      this.checksum =
          this._crc8DVBS2(this.checksum, this.payload.getInt8(index));
    }

    if (this.checksum != recievedChecksum) {
      this.error =
          ("Read error checksums did not match ${this.checksum}:$recievedChecksum");
      print(this.error);
      return false;
    }

    // List<int> rData = byteData
    //     .getRange(
    //         this._dataStartOffset, this._dataStartOffset + this.payloadLength)
    //     .toList();

    // this.payload = new ByteData.view(Uint8List.fromList(rData).buffer);
    return true;
  }
}

class MSPMessageRequest extends MSPMessage {
  MSPMessageRequest(int code, {Uint8List? payloadData}) {
    if (payloadData != null) {
      this.payload = new ByteData.view(payloadData.buffer);
    } else {
      this.payload = new ByteData(MSPMessage.structLength);
    }

    this.function = code;
    int length = this.payload.buffer.lengthInBytes;
    this.payloadLength = length > 0 ? length : 0;
    this.msgLength = this.payloadLength + MSPMessage.structLength;
    this._buildRequest();
  }

  // Used to build the message
  late Uint8List _buffer;

  Uint8List _buildRequest() {
    // Send/Recieve buffer
    this._buffer = new Uint8List(this.msgLength);

    // Assign the bugger with the request header
    this.header = new RequestMessageHeader(this._buffer);

    // Flag: reserved, set to 0
    this._buffer[this._flagOffset] = this.flag;
    // Code lower byte
    this._buffer[this._functionLowOffset] = function & 0xFF;
    // Code upper byte
    this._buffer[this.__functionHighOffset] = (function & 0xFF00) >> 8;
    // PayloadLength lower byte
    this._buffer[this._payloadLengthLowOffset] = payloadLength & 0xFF;
    // PayloadLength upper byte
    this._buffer[this._payloadLengthHighOffset] = (payloadLength & 0xFF00) >> 8;

    this._addData();

    this._buffer[this.msgLength - 1] =
        this._checksum(this._buffer.buffer.asUint8List());

    return this._buffer;
  }

  _addData() {
    int start = this._dataStartOffset;
    for (int ii = 0; ii < payloadLength; ii++) {
      this._buffer[start + ii] = this._buffer.elementAt(ii);
    }
  }

  int write(SerialPort serialPort, {int timeout = 10}) {
    serialPort.drain();
    serialPort.flush();
    int data = serialPort.write(this._buffer, timeout: timeout);
    serialPort.drain();
    return data;
  }
}
