import 'dart:convert';
import 'dart:typed_data';
import 'package:inavconfiurator/msp/codes/base_data_handler.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';

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
