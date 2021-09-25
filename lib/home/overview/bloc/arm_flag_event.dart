part of 'arm_flag_bloc.dart';

@immutable
abstract class ArmFlagEvent {}

class GotStatusEvent extends ArmFlagEvent {
  final MSPINavStatus inavStatus;

  GotStatusEvent({
    required this.inavStatus,
  });
}
