import 'dart:typed_data';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:inavconfiurator/msp/codes/base_data_handler.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';

class MSPAttitude implements MSPDataHandler {
  final MSPMessageResponse messageResponse;
  final int code = MSPCodes.mspAttitude;

  final Vector3 kinematics = new Vector3.zero();

  MSPAttitude(this.messageResponse) {
    ByteData payload = this.messageResponse.payload;

    double roll = (payload.getInt16(0, Endian.little) / 10.0);
    double pitch = (payload.getInt16(2, Endian.little) / 10.0);
    double heading = (payload.getInt16(4, Endian.little).toDouble());

    this.kinematics.setValues(roll, pitch, heading);
  }
}