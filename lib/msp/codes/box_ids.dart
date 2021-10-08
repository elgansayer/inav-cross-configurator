import '../codes.dart';
import '../msp_message.dart';
import 'base_data_handler.dart';

class MSPBoxIds implements MSPDataHandler {
  MSPBoxIds(this.messageResponse) {
    print(this.messageResponse);
  }

  final int code = MSPCodes.mspBoxIds;
  final MSPMessageResponse messageResponse;
}
