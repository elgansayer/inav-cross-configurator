import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../codes.dart';
import '../msp_message.dart';
import 'base_data_handler.dart';

class MSPBoxIds implements MSPDataHandler {
  MSPBoxIds(this.messageResponse) {
    ByteData payload = this.messageResponse.payload;
    this.ids = payload.buffer.asUint8List().toList();
  }

  final int code = MSPCodes.mspBoxIds;
  late List<int> ids;
  final MSPMessageResponse messageResponse;
}
