import 'dart:typed_data';
import 'package:inavconfiurator/msp/codes/base_data_handler.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';

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
    Uint8List payload = this.messageResponse.payload;
    this.mspProtocolVersion = payload[0];
    this.apiVersionMajor = payload[1];
    this.apiVersionMinor = payload[2];
    this.apiVersionPatch = 0;
  }
}
