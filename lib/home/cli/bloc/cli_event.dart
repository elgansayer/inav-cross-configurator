part of 'cli_bloc.dart';

@immutable
abstract class CliEvent {}

class SendCliCmdEvent extends CliEvent {
  final String cliCmd;

  SendCliCmdEvent({
    required this.cliCmd,
  });
}

class RecievedRawCliEvent extends CliEvent {
  final List<int> data;
  RecievedRawCliEvent({
    required this.data,
  });
}

class ExitCliEvent extends CliEvent {
  ExitCliEvent();
}

class ExitedCliEvent extends CliEvent {
  ExitedCliEvent();
}

class EnterCliEvent extends CliEvent {
  EnterCliEvent();
}
