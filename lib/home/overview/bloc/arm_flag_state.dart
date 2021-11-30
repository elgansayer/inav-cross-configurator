part of 'arm_flag_bloc.dart';

@immutable
class ArmFlagState {
  ArmFlagState({
    required this.inavStatus,
    required this.armFlags,
  });

  factory ArmFlagState.gotStatus(
      {required MSPINavStatus inavStatus,
      required Iterable<ArmFlag> armFlags}) {
    return ArmFlagState(
      inavStatus: inavStatus,
      armFlags: armFlags,
    );
  }

  factory ArmFlagState.init() {
    return ArmFlagState(inavStatus: null, armFlags: []);
  }

  final Iterable<ArmFlag> armFlags;
  final MSPINavStatus? inavStatus;
}
