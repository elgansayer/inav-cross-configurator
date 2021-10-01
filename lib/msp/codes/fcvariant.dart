import 'dart:convert';
import 'dart:typed_data';

import '../codes.dart';
import '../msp_message.dart';
import 'base_data_handler.dart';

class MSPFcVariant implements MSPDataHandler {
  final MSPMessageResponse messageResponse;
  final int code = MSPCodes.mspFcVariant;
  late String flightControllerIdentifier;

  MSPFcVariant(this.messageResponse) {
    ByteData payload = this.messageResponse.payload;
    List<int> identifiers = payload.buffer.asInt8List().getRange(0, 4).toList();
    this.flightControllerIdentifier = ascii.decode(identifiers);
  }
}
