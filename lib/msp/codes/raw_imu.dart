import 'dart:typed_data';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:inavconfiurator/msp/codes/base_data_handler.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';

class MSPRawImu implements MSPDataHandler {
  final MSPMessageResponse messageResponse;
  final int code = MSPCodes.mspRawImu;

  // A 3-vector value containing the raw accelerometer values
  // in the x, y and z axes respectively. The units depend on the device.
  final Vector3 accelerometer = new Vector3.zero();
  // A 3-vector value containing the raw gyroscope values
  // in the x, y and z axes respectively. The units depend on the device.
  final Vector3 gyroscope = new Vector3.zero();
  // A 3-vector value containing the raw magnetometer values
  // in the x, y and z axes respectively. The units depend on the device.
  final Vector3 magnetometer = new Vector3.zero();

  MSPRawImu(this.messageResponse) {
    ByteData byteData = this.messageResponse.payload;
    // ByteData byteData = new ByteData.view(payload.buffer);

    // unit: it depends on ACC sensor and is based on ACC_1G definition
    // MMA7455 64 / MMA8451Q 512 / ADXL345 265 / BMA180 255 / BMA020 63 / NUNCHUCK 200 / LIS3LV02 256 / LSM303DLx_ACC 256 / MPU6050 512 / LSM330 256
    double accX = (byteData.getInt16(0, Endian.little) / 512);
    double accY = (byteData.getInt16(2, Endian.little) / 512);
    double accZ = (byteData.getInt16(4, Endian.little) / 512);
    this.accelerometer.setValues(accX, accY, accZ);

    // unit: it depends on GYRO sensor.
    // For MPU6050, 1 unit = 1/4.096 deg/s
    double gyroX = (byteData.getInt16(6, Endian.little) * (4 / 16.4));
    double gyroY = (byteData.getInt16(8, Endian.little) * (4 / 16.4));
    double gyroZ = (byteData.getInt16(10, Endian.little) * (4 / 16.4));
    this.gyroscope.setValues(gyroX, gyroY, gyroZ);

    // unit: it depends on MAG sensor.
    double magX = (byteData.getInt16(12, Endian.little) / 1090);
    double magY = (byteData.getInt16(14, Endian.little) / 1090);
    double magZ = (byteData.getInt16(16, Endian.little) / 1090);
    this.magnetometer.setValues(magX, magY, magZ);
  }
}
