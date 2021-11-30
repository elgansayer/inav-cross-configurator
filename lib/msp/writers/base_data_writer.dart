import 'dart:typed_data';

import 'package:inavconfigurator/msp/msp_message.dart';

class MSPRequestBuilder {
  MSPRequestBuilder() {
    this.buffer = [];
  }

  late List<int> buffer;
  late int code;

  toRequest() {
    // int code, {Uint8List? payloadData
    Uint8List payloadData = new Uint8List.fromList(this.buffer);
    MSPMessageRequest request =
        MSPMessageRequest(this.code, payloadData: payloadData);
    return request;
  }

  int highByte(double value) {
    return value.toInt() >> 8;
  }

  int lowByte(double value) {
    return 0x00FF & value.toInt();
  }
}
