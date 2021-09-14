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
  final Uint8List data;
  RecievedRawCliEvent({
    required this.data,
  });
}
