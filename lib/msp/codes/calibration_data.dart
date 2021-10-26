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

    this.acc = List<int>.generate(6, (index) {
      return (1 & (callibrations >> index));
    });

    double accX = payload.getInt16(1, Endian.little).toDouble();
    double accY = payload.getInt16(3, Endian.little).toDouble();
    double accZ = payload.getInt16(5, Endian.little).toDouble();
    this.accZero = Vector3(accX, accY, accZ);

    double accGainX = payload.getInt16(7, Endian.little).toDouble();
    double accGainY = payload.getInt16(9, Endian.little).toDouble();
    double accGainZ = payload.getInt16(11, Endian.little).toDouble();
    this.accGain = Vector3(accGainX, accGainY, accGainZ);

    double magZeroX = payload.getInt16(13, Endian.little).toDouble();
    double magZeroY = payload.getInt16(15, Endian.little).toDouble();
    double magZeroZ = payload.getInt16(17, Endian.little).toDouble();
    this.magZero = Vector3(magZeroX, magZeroY, magZeroZ);

    this.opflowScale = (payload.getInt16(19, Endian.little) / 256.0).toDouble();

    double magGainX = payload.getInt16(21, Endian.little).toDouble();
    double magGainY = payload.getInt16(23, Endian.little).toDouble();
    double magGainZ = payload.getInt16(25, Endian.little).toDouble();
    this.magGain = Vector3(magGainX, magGainY, magGainZ);
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
