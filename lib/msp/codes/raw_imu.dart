import 'dart:typed_data';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:inavconfiurator/msp/codes/base_data_handler.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';

class MSPRawImu implements MSPDataHandler {
  final MSPMessageResponse messageResponse;
  final int code = MSPCodes.mspRawImu;

  final Vector3 accelerometer = new Vector3.zero();
  final Vector3 gyroscope = new Vector3.zero();
  final Vector3 magnetometer = new Vector3.zero();

  MSPRawImu(this.messageResponse) {
    Uint8List payload = this.messageResponse.payload;
    ByteData byteData = new ByteData.view(payload.buffer);

    double accX = (byteData.getInt16(0, Endian.little) / 512);
    double accY = (byteData.getInt16(2, Endian.little) / 512);
    double accZ = (byteData.getInt16(4, Endian.little) / 512);
    this.accelerometer.setValues(accX, accY, accZ);

    double gyroX = (byteData.getInt16(6, Endian.little) * (4 / 16.4));
    double gyroY = (byteData.getInt16(8, Endian.little) * (4 / 16.4));
    double gyroZ = (byteData.getInt16(10, Endian.little) * (4 / 16.4));
    this.gyroscope.setValues(gyroX, gyroY, gyroZ);

    double magX = (byteData.getInt16(12, Endian.little) / 1090);
    double magY = (byteData.getInt16(14, Endian.little) / 1090);
    double magZ = (byteData.getInt16(16, Endian.little) / 1090);
    this.magnetometer.setValues(magX, magY, magZ);
  }
}
