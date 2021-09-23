import 'codes/api_version.dart';
import 'codes/attitude.dart';
import 'codes/fcvariant.dart';
import 'codes/raw_imu.dart';
import 'codes.dart';
import 'mspmessage.dart';

abstract class MSPDataClassTransformers {
  static Map<int, Function> classBuilder = {
    MSPCodes.mspApiVersion: (MSPMessageResponse data) => MSPApiVersion(data),
    MSPCodes.mspFcVariant: (MSPMessageResponse data) => MSPFcVariant(data),
    MSPCodes.mspRawImu: (MSPMessageResponse data) => MSPRawImu(data),
    MSPCodes.mspAttitude: (MSPMessageResponse data) => MSPAttitude(data),
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
