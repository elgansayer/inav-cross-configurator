import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/app/bloc/app_bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:meta/meta.dart';

part 'cli_event.dart';
part 'cli_state.dart';

class CliBloc extends Bloc<CliEvent, CliState> {
  CliBloc({required this.serialDeviceRepository, required this.appBloc})
      : super(CliState.init()) {
    this._enterCliMode();
    this._listen();
  }

  final AppBloc appBloc;
  final SerialDeviceRepository serialDeviceRepository;

  late StreamSubscription<Uint8List> _rawListener;

  @override
  Future<void> close() async {
    _rawListener.cancel();
    super.close();
  }

  @override
  Stream<CliState> mapEventToState(
    CliEvent event,
  ) async* {
    if (event is SendCliCmdEvent) {
      yield* this._handleCliCmd(event);
    }

    if (event is ExitCliEvent) {
      yield* this._exitCliMode();
    }

    if (event is ExitedCliEvent) {
      yield CliState.exited(
        this.state.messages,
      );

      // Now reconnect after a short display delay
      Timer(Duration(milliseconds: 250), () {
        this.appBloc.add(ReconnectEvent());
      });
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

    yield CliState.data(
      newMsgs,
    );

    // Lazy check, if we are exiting. Then change state
    // to reflect that
    if (newMsg.contains('Leaving CLI mode')) {
      this.add(ExitedCliEvent());
    }
  }

  _exitCliMode() {
    final cmdEx = "exit";
    _sendCliCmd(cmdEx);

    // Now we should be back, and have sent exit
    // but wait a second anyway
  }

  _enterCliMode() {
    final cmdEx = "#";
    serialDeviceRepository.writeString(cmdEx);
  }

  Stream<CliState> _handleCliCmd(SendCliCmdEvent event) async* {
    final String cmd = event.cliCmd.toLowerCase();

    // Does this cmd start with a #? if so, ignore it
    if (cmd.startsWith('#')) {
      return;
    }

    // Custom commands?
    switch (cmd) {
      case 'clear':
        yield* _handleClearCmd();
        break;
      default:
        this._sendCliCmd(cmd);
    }
  }

  Stream<CliState> _handleClearCmd() async* {
    yield CliState.init();
  }

  _sendCliCmd(String cmd) {
    final cmdEx = "$cmd\n";
    return serialDeviceRepository.writeString(cmdEx);
  }
}
