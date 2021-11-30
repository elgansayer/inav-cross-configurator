part of 'overview_bloc.dart';

@immutable
class InfoState {
  InfoState({
    required this.inavStatus,
    required this.armFlags,
  });

  factory InfoState.gotStatus(
      {required MSPINavStatus inavStatus,
      required Iterable<ArmFlag> armFlags}) {
    return InfoState(
      inavStatus: inavStatus,
      armFlags: armFlags,
    );
  }

  factory InfoState.init() {
    return InfoState(inavStatus: null, armFlags: []);
  }

  final Iterable<ArmFlag> armFlags;
  final MSPINavStatus? inavStatus;
}
