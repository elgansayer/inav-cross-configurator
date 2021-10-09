import 'dart:convert';
import 'dart:typed_data';

import '../codes.dart';
import '../msp_message.dart';
import 'base_data_handler.dart';

class MSPBoxNames implements MSPDataHandler {
  MSPBoxNames(this.messageResponse) {
    Uint8List payload = this.messageResponse.payload.buffer.asUint8List();

    int delim = 0x3B;

    Iterable<MapEntry<int, int>> wordsAsBytes =
        payload.asMap().entries.where((word) => word.value == delim);

    for (var i = 0; i < wordsAsBytes.length; i++) {
      int end = wordsAsBytes.elementAt(i).key;
      int start = (i == 0 ? 0 : wordsAsBytes.elementAt(i - 1).key) + 1;

      Uint8List wholeWordBytes = payload.sublist(start, end);
      String word = ascii.decode(wholeWordBytes);
      this.names.add(word);
    }
  }

  final int code = MSPCodes.mspBoxNames;
  final MSPMessageResponse messageResponse;
  final List<String> names = [];
}
