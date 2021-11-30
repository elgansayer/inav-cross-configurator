part of 'overview_bloc.dart';

@immutable
abstract class InfoEvent {}

class GotStatusEvent extends InfoEvent {
  GotStatusEvent({
    required this.inavStatus,
  });

  final MSPINavStatus inavStatus;
}
