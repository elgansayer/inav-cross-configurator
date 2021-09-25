part of 'arm_flag_bloc.dart';

@immutable
class ArmFlagState {
  final MSPINavStatus? inavStatus;
  final Iterable<ArmFlag> armFlags;

  ArmFlagState({
    required this.inavStatus,
    required this.armFlags,
  });

  factory ArmFlagState.init() {
    return ArmFlagState(inavStatus: null, armFlags: []);
  }

  factory ArmFlagState.gotStatus(
      {required MSPINavStatus inavStatus,
      required Iterable<ArmFlag> armFlags}) {
    return ArmFlagState(
      inavStatus: inavStatus,
      armFlags: armFlags,
    );
  }
}
