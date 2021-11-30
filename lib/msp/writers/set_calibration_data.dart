import 'package:flutter_cube/flutter_cube.dart';

import '../codes.dart';
import 'base_data_writer.dart';

class SetCalibrationData extends MSPRequestBuilder {
  SetCalibrationData({
    required this.acc,
    required this.accGain,
    required this.accZero,
    required this.magGain,
    required this.magZero,
    required this.opflowScale,
  }) {
    _build();
  }

  List<int> acc;
  Vector3 accGain;
  Vector3 accZero;
  final int code = MSPCodes.mspSetCalibrationData;
  Vector3 magGain;
  Vector3 magZero;
  double opflowScale;

  _build() {
    this.buffer = [];

    buffer.add(lowByte(this.accZero.x));
    buffer.add(highByte(this.accZero.x));

    buffer.add(lowByte(this.accZero.y));
    buffer.add(highByte(this.accZero.y));

    buffer.add(lowByte(this.accZero.z));
    buffer.add(highByte(this.accZero.z));

    buffer.add(lowByte(this.accGain.x));
    buffer.add(highByte(this.accGain.x));

    buffer.add(lowByte(this.accGain.y));
    buffer.add(highByte(this.accGain.y));

    buffer.add(lowByte(this.accGain.z));
    buffer.add(highByte(this.accGain.z));

    buffer.add(lowByte(this.magZero.x));
    buffer.add(highByte(this.magZero.x));

    buffer.add(lowByte(this.magZero.y));
    buffer.add(highByte(this.magZero.y));

    buffer.add(lowByte(this.magZero.z));
    buffer.add(highByte(this.magZero.z));

    buffer.add(lowByte((this.opflowScale * 256)));
    buffer.add(highByte((this.opflowScale * 256)));

    buffer.add(lowByte(this.magGain.x));
    buffer.add(highByte(this.magGain.x));

    buffer.add(lowByte(this.magGain.y));
    buffer.add(highByte(this.magGain.y));

    buffer.add(lowByte(this.magGain.z));
    buffer.add(highByte(this.magGain.z));
  }
}
