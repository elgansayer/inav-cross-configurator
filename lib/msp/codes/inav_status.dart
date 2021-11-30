import 'dart:typed_data';
import 'base_data_handler.dart';
import '../codes.dart';
import '../msp_message.dart';

class MSPINavStatus implements MSPDataHandler {
  MSPINavStatus(this.messageResponse) {
    ByteData payload = this.messageResponse.payload;

    this.cycleTime = payload.getUint16(0, Endian.little);
    this.i2cError = payload.getUint16(2, Endian.little);
    this.activeSensors = payload.getUint16(4, Endian.little);
    this.cpuload = payload.getUint16(6, Endian.little);

    int profileByte = payload.getUint8(9);
    this.profile = profileByte & 0x0F;
    this.batteryProfile = (profileByte & 0xF0) >> 4;

    this.armingFlags = payload.getUint32(9, Endian.little);
  }

  late int activeSensors;
  late int armingFlags;
  late int batteryProfile;
  final int code = MSPCodes.mspv2InavStatus;
  late int cpuload;
  late int cycleTime;
  late int i2cError;
  final MSPMessageResponse messageResponse;
  late int profile;
}
