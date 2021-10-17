import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_cube/flutter_cube.dart';

import '../codes.dart';
import '../msp_message.dart';
import 'base_data_handler.dart';

class MSPCalibrationData implements MSPDataHandler {
  MSPCalibrationData(this.messageResponse) {
    ByteData payload = messageResponse.payload;
    int callibrations = payload.getUint8(0);

    this.acc = List<int>.generate(5, (index) {
      return (1 & (callibrations >> index));
    });

    this.accZero.x = payload.getInt16(1, Endian.little).toDouble();
    this.accZero.y = payload.getInt16(3, Endian.little).toDouble();
    this.accZero.z = payload.getInt16(5, Endian.little).toDouble();

    this.accGain.x = payload.getInt16(7, Endian.little).toDouble();
    this.accGain.y = payload.getInt16(9, Endian.little).toDouble();
    this.accGain.z = payload.getInt16(11, Endian.little).toDouble();

    this.magZero.x = payload.getInt16(13, Endian.little).toDouble();
    this.magZero.t = payload.getInt16(15, Endian.little).toDouble();
    this.magZero.z = payload.getInt16(17, Endian.little).toDouble();
    this.opflowScale = (payload.getInt16(19, Endian.little) / 256.0).toDouble();

    this.magGain.x = payload.getInt16(21, Endian.little).toDouble();
    this.magGain.y = payload.getInt16(23, Endian.little).toDouble();
    this.magGain.z = payload.getInt16(25, Endian.little).toDouble();
  }

  late List<int> acc;
  late Vector3 accGain;
  late Vector3 accZero;
  late Vector3 magGain;
  late Vector3 magZero;
  late double opflowScale;
  final int code = MSPCodes.mspCalibrationData;
  final MSPMessageResponse messageResponse;
}
