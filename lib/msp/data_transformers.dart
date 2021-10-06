import 'package:inavconfigurator/msp/codes/inav_status.dart';
import 'package:inavconfigurator/msp/codes/mode_ranges.dart';
import 'package:inavconfigurator/msp/codes/status_ex.dart';

import 'codes/api_version.dart';
import 'codes/attitude.dart';
import 'codes/box_ids.dart';
import 'codes/box_names.dart';
import 'codes/fcvariant.dart';
import 'codes/raw_imu.dart';
import 'codes.dart';
import 'msp_message.dart';

abstract class MSPDataClassTransformers {
  static Map<int, Function> classBuilder = {
    MSPCodes.mspApiVersion: (MSPMessageResponse data) => MSPApiVersion(data),
    MSPCodes.mspFcVariant: (MSPMessageResponse data) => MSPFcVariant(data),
    MSPCodes.mspRawImu: (MSPMessageResponse data) => MSPRawImu(data),
    MSPCodes.mspAttitude: (MSPMessageResponse data) => MSPAttitude(data),
    MSPCodes.mspStatusEx: (MSPMessageResponse data) => MSPStatusEx(data),
    MSPCodes.mspv2InavStatus: (MSPMessageResponse data) => MSPINavStatus(data),
    MSPCodes.mspModeRanges: (MSPMessageResponse data) => MSPModeRanges(data),
    MSPCodes.mspBoxNames: (MSPMessageResponse data) => MSPBoxNames(data),
    MSPCodes.mspBoxIds: (MSPMessageResponse data) => MSPBoxIds(data),
  };

  static register(int code, Function builder) {
    classBuilder[code] = builder;
  }

  static T? transform<T>(int code, MSPMessageResponse data) {
    if (!classBuilder.containsKey(code)) {
      return null;
    }

    return MSPDataClassTransformers.classBuilder[code]!(data);
  }
}
