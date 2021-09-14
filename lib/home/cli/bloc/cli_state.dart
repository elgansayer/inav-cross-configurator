part of 'cli_bloc.dart';

class CliState {
  List<String> messages;
  String get message => this.messages.reduce((value, str) => value += "$str\n");

  CliState({
    required this.messages,
  });

  factory CliState.init() {
    return CliState(messages: List<String>.empty());
  }

  factory CliState.data(List<String> messages) {
    return CliState(messages: messages);
  }
}
