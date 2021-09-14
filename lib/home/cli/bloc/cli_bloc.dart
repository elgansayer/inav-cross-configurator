import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:meta/meta.dart';

part 'cli_event.dart';
part 'cli_state.dart';

class CliBloc extends Bloc<CliEvent, CliState> {
  CliBloc({required this.serialDeviceRepository}) : super(CliState.init()) {
    this._enterCliMode();
    this._listen();
  }

  late SerialDeviceRepository serialDeviceRepository;

  late StreamSubscription<Uint8List> _rawListener;

  @override
  Future<void> close() async {
    this._exitCliMode();
    _rawListener.cancel();
    super.close();
  }

  @override
  Stream<CliState> mapEventToState(
    CliEvent event,
  ) async* {
    if (event is SendCliCmdEvent) {
      this._sendCliCmd(event);
    }

    if (event is RecievedRawCliEvent) {
      yield* this._recievedRawCliEvent(event);
    }
  }

  _listen() {
    this._rawListener =
        serialDeviceRepository.responseRaw.listen((Uint8List event) {
      this.add(RecievedRawCliEvent(data: event));
    });
  }

  Stream<CliState> _recievedRawCliEvent(RecievedRawCliEvent event) async* {
    final newMsg = ascii.decode(event.data);
    final newMsgs = [...state.messages, newMsg];
    yield CliState(
      messages: newMsgs,
    );
  }

  _exitCliMode() {
    final cmdEx = "exit\r";
    serialDeviceRepository.writeString(cmdEx);
  }

  _enterCliMode() {
    final cmdEx = "#";
    serialDeviceRepository.writeString(cmdEx);
  }

  _sendCliCmd(SendCliCmdEvent event) {
    final String cmd = event.cliCmd;
    final cmdEx = "$cmd\n";
    serialDeviceRepository.writeString(cmdEx);
  }
}