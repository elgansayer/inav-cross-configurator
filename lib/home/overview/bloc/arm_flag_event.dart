part of 'arm_flag_bloc.dart';

@immutable
abstract class ArmFlagEvent {}

class GotStatusEvent extends ArmFlagEvent {
  GotStatusEvent({
    required this.inavStatus,
  });

  final MSPINavStatus inavStatus;
}
