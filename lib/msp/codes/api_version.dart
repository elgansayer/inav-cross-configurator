import 'dart:typed_data';

import '../codes.dart';
import '../msp_message.dart';
import 'base_data_handler.dart';

class MSPApiVersion implements MSPDataHandler {
  final MSPMessageResponse messageResponse;
  final int code = MSPCodes.mspApiVersion;

  late int mspProtocolVersion;
  late int apiVersionMajor;
  late int apiVersionMinor;
  late int apiVersionPatch;

  String get apiVersion =>
      "${this.apiVersionMajor}.${this.apiVersionMinor}.${this.apiVersionPatch}";

  MSPApiVersion(this.messageResponse) {
    ByteData payload = this.messageResponse.payload;

    this.mspProtocolVersion = payload.getInt8(0);
    this.apiVersionMajor = payload.getInt8(1);
    this.apiVersionMinor = payload.getInt8(2);
    this.apiVersionPatch = 0;
  }
}
