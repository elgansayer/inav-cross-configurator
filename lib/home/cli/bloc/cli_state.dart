part of 'cli_bloc.dart';

class CliState {
  bool connected;
  bool excitedCli;
  int timerTimer;
  List<String> messages;
  String get message => this
      .messages
      .join(); // this.messages.reduce((value, str) => value += "$str\n");

  CliState({
    required this.messages,
    required this.excitedCli,
    required this.timerTimer,
    required this.connected,
  });

  factory CliState.init() {
    return CliState(
        messages: List<String>.empty(),
        excitedCli: false,
        timerTimer: 0,
        connected: false);
  }

  factory CliState.data(List<String> messages) {
    return CliState(
        messages: messages, excitedCli: false, timerTimer: 0, connected: true);
  }

  factory CliState.exited(List<String> messages) {
    return CliState(
        messages: messages, excitedCli: true, timerTimer: 0, connected: false);
  }
}
