import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:inavconfigurator/models/mode_range.dart';
import '../codes.dart';
import '../mspmessage.dart';
import 'base_data_handler.dart';

class MSPModeRanges implements MSPDataHandler {
  final MSPMessageResponse messageResponse;
  final int code = MSPCodes.mspModeRanges;
  final List<ModeRange> modes = [];

  MSPModeRanges(this.messageResponse) {
    ByteData payload = this.messageResponse.payload;

    // 4 bytes per item.
    double modeRangeCount = payload.lengthInBytes / 4;

    int offset = 0;
    for (var i = 0; offset < payload.lengthInBytes && i < modeRangeCount; i++) {
      int id = payload.getUint8(offset++);
      int auxChannelIndex = payload.getUint8(offset++);
      double start = 900 + (payload.getUint8(offset++) * 25);
      double end = 900 + (payload.getUint8(offset++) * 25);

      ModeRange mode = ModeRange(
          id: id,
          auxChannelIndex: auxChannelIndex,
          range: RangeValues(start, end));

      this.modes.add(mode);
    }
  }
}
