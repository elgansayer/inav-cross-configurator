part of 'overview_bloc.dart';

@immutable
abstract class InfoEvent {}

class GotStatusEvent extends InfoEvent {
  final MSPINavStatus inavStatus;

  GotStatusEvent({
    required this.inavStatus,
  });
}
