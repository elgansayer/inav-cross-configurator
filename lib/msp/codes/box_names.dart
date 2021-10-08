import '../codes.dart';
import '../msp_message.dart';
import 'base_data_handler.dart';

class MSPBoxNames implements MSPDataHandler {
  MSPBoxNames(this.messageResponse) {
    print(this.messageResponse);
  }

  final int code = MSPCodes.mspBoxNames;
  final MSPMessageResponse messageResponse;
}
