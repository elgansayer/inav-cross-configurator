import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../../serial/serialdevice_repository.dart';

part 'cli_event.dart';
part 'cli_state.dart';

class CliBloc extends Bloc<CliEvent, CliState> {
  CliBloc({required this.serialDeviceRepository, required this.appBloc})
      : super(CliState.init()) {
    on<SendCliCmdEvent>((event, emit) => this._handleCliCmd(event, emit));
    on<EnterCliEvent>((event, emit) => this._enterCliMode());
    on<ExitCliEvent>((event, emit) => this._exitCliMode());
    on<ExitedCliEvent>((event, emit) => this._exitedCliEvent(event, emit));
    on<RecievedRawCliEvent>(
        (event, emit) => this._recievedRawCliEvent(event, emit));

    this._countDown();
  }

  final AppBloc appBloc;
  final SerialDeviceRepository serialDeviceRepository;
  late StreamSubscription<List<int>> _rawListener;

  @override
  Future<void> close() async {
    _rawListener.cancel();
    super.close();
  }

  _exitedCliEvent(event, emit) {
    emit(CliState.exited(
      this.state.messages,
    ));

    // Now reconnect after a short display delay
    Timer(Duration(milliseconds: 250), () {
      this.appBloc.add(ReconnectEvent());
    });
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

  _listen() {
    this._rawListener =
        serialDeviceRepository.responseRaw.listen((List<int> event) {
      this.add(RecievedRawCliEvent(data: event));
    });
  }

  _recievedRawCliEvent(RecievedRawCliEvent event, emit) {
    final newMsg = ascii.decode(event.data);
    List<String> newMsgs = List<String>.from(state.messages);
    newMsgs.add(newMsg);

    emit(CliState.data(
      newMsgs,
    ));

    // Lazy check, if we are exiting. Then change state
    // to reflect that
    List<String> checks = ['Rebooting', 'Leaving CLI mode'];
    if (checks.any((element) => newMsg.contains(element))) {
      this.add(ExitedCliEvent());
    }
  }

  _exitCliMode() {
    final cmdEx = "exit";
    _sendCliCmd(cmdEx);
  }

  _enterCliMode() {
    this._listen();
    final cmdEx = "#";
    _sendCliCmd(cmdEx);
  }

  _handleCliCmd(SendCliCmdEvent event, emit) {
    final String cmd = event.cliCmd.toLowerCase();

    // Does this cmd start with a #? if so, ignore it
    if (cmd.startsWith('#')) {
      return;
    }

    // Custom commands?
    switch (cmd) {
      case 'clear':
        _handleClearCmd(emit);
        break;
      default:
        this._sendCliCmd(cmd);
    }
  }

  Stream<CliState> _handleClearCmd(emit) async* {
    emit(CliState.data(List<String>.empty()));
  }

  _sendCliCmd(String cmd) {
    final cmdEx = "$cmd\n";
    return serialDeviceRepository.writeString(cmdEx);
  }
}
