part of 'overview_bloc.dart';

@immutable
class InfoState {
  final MSPINavStatus? inavStatus;
  final Iterable<ArmFlag> armFlags;

  InfoState({
    required this.inavStatus,
    required this.armFlags,
  });

  factory InfoState.init() {
    return InfoState(inavStatus: null, armFlags: []);
  }

  factory InfoState.gotStatus(
      {required MSPINavStatus inavStatus,
      required Iterable<ArmFlag> armFlags}) {
    return InfoState(
      inavStatus: inavStatus,
      armFlags: armFlags,
    );
  }
}
