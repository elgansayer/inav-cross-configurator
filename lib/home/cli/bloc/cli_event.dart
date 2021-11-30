part of 'cli_bloc.dart';

@immutable
abstract class CliEvent {}

class SendCliCmdEvent extends CliEvent {
  SendCliCmdEvent({
    required this.cliCmd,
  });

  final String cliCmd;
}

class RecievedRawCliEvent extends CliEvent {
  RecievedRawCliEvent({
    required this.data,
  });

  final List<int> data;
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
