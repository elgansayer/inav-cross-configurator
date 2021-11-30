import 'dart:typed_data';
import 'package:flutter_cube/flutter_cube.dart';
import 'base_data_handler.dart';
import '../codes.dart';
import '../msp_message.dart';

class MSPAttitude implements MSPDataHandler {
  MSPAttitude(this.messageResponse) {
    ByteData payload = this.messageResponse.payload;

    double roll = (payload.getInt16(0, Endian.little) / 10.0);
    double pitch = (payload.getInt16(2, Endian.little) / 10.0);
    double heading = (payload.getInt16(4, Endian.little).toDouble());

    this.kinematics.setValues(roll, pitch, heading);
  }

  final int code = MSPCodes.mspAttitude;
  final Vector3 kinematics = new Vector3.zero();
  final MSPMessageResponse messageResponse;
}
