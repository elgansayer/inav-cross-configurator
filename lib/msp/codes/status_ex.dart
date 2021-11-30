import 'dart:typed_data';
import 'base_data_handler.dart';
import '../codes.dart';
import '../msp_message.dart';

class MSPStatusEx implements MSPDataHandler {
  MSPStatusEx(this.messageResponse) {
    ByteData payload = this.messageResponse.payload;

    this.cycleTime = payload.getInt16(0, Endian.little);
    this.i2cError = payload.getInt16(2, Endian.little);
    this.activeSensors = payload.getInt16(4, Endian.little);
    this.profile = payload.getInt16(10, Endian.big);
    this.cpuload = payload.getInt16(11, Endian.little);
    this.armingFlags = payload.getInt16(13, Endian.little);
  }

  late int activeSensors;
  late int armingFlags;
  final int code = MSPCodes.mspStatusEx;
  late int cpuload;
  late int cycleTime;
  late int i2cError;
  final MSPMessageResponse messageResponse;
  late int profile;
}
