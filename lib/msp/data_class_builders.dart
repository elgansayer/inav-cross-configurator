import 'package:inavconfiurator/msp/builders/api_version.dart';
import 'package:inavconfiurator/msp/builders/fcvariant.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';

abstract class MSPDataClassBuilders {
  static Map<int, Function> classBuilder = {
    MSPCodes.mspApiVersion: (MSPMessageResponse data) => MSPApiVersion(data),
    MSPCodes.mspFcVariant: (MSPMessageResponse data) => MSPFcVariant(data),
  };

  static get(int code, MSPMessageResponse data) {
    if (!classBuilder.containsKey(code)) {
      return;
    }

    return MSPDataClassBuilders.classBuilder[code]!(data);
  }
}
