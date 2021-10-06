import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:inavconfigurator/models/mode_range.dart';
import '../codes.dart';
import '../msp_message.dart';
import 'base_data_handler.dart';

class MSPBoxNames implements MSPDataHandler {
  final MSPMessageResponse messageResponse;
  final int code = MSPCodes.mspBoxNames;

  MSPBoxNames(this.messageResponse) {
    print(this.messageResponse);
  }
}
