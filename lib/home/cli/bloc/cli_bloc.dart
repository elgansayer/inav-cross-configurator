import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../../serial/serialdevice_repository.dart';

part 'cli_event.dart';
part 'cli_state.dart';

class CliBloc extends Bloc<CliEvent, CliState> {
  CliBloc({required this.serialDeviceRepository, required this.appBloc})
      : super(CliState.init()) {
    this._countDown();
  }

  _countDown() {
    // Try to ensure we are ready for cli
    this.serialDeviceRepository.flush();
    this.serialDeviceRepository.drain();

    // Not really needed, but it looks cool
    // and helps get the board ready
    Future.delayed(new Duration(milliseconds: 150), () {
      this.add(EnterCliEvent());
    });
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
    if (event is EnterCliEvent) {
      print("_enterCliMode");
      this._listen();
      this._enterCliMode();
    }

    if (event is SendCliCmdEvent) {
      yield* this._handleCliCmd(event);
    }

    if (event is ExitCliEvent) {
      this._exitCliMode();
      yield this.state;
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
      try {
        yield* this._recievedRawCliEvent(event);
      } catch (e) {
        yield this.state;
      }
    }
  }

  _listen() {
    this._rawListener =
        serialDeviceRepository.responseRaw.listen((Uint8List event) {
      this.add(RecievedRawCliEvent(data: event));
    });
  }

  Stream<CliState> _recievedRawCliEvent(RecievedRawCliEvent event) async* {
    try {
      final newMsg = ascii.decode(event.data);
      final newMsgs = [...state.messages, newMsg];

      yield CliState.data(
        newMsgs,
      );

      // Lazy check, if we are exiting. Then change state
      // to reflect that
      List<String> checks = ['Rebooting', 'Leaving CLI mode'];
      if (checks.any((element) => newMsg.contains(element))) {
        this.add(ExitedCliEvent());
      }
    } catch (e) {
      yield this.state;
    }
  }

  _exitCliMode() {
    final cmdEx = "exit";
    _sendCliCmd(cmdEx);
  }

  _enterCliMode() {
    final cmdEx = "#";
    _sendCliCmd(cmdEx);
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
    yield CliState.data(List<String>.empty());
  }

  _sendCliCmd(String cmd) {
    final cmdEx = "$cmd\n";
    return serialDeviceRepository.writeString(cmdEx);
  }
}
