part of 'modes_bloc.dart';

@immutable
class ModesState {
  final List<ModeInfo> modes;
  final List<ModeRange> modeRanges;
  final List<String> names;
  final List<int> ids;

  ModesState({
    required this.modes,
    required this.modeRanges,
    required this.names,
    required this.ids,
  });

  factory ModesState.initial() {
    return new ModesState(modeRanges: [], modes: [], names: [], ids: []);
  }

  ModesState copyWith({
    List<ModeInfo>? modes,
    List<ModeRange>? modeRanges,
    List<String>? names,
    List<int>? ids,
  }) {
    return ModesState(
      modes: modes ?? this.modes,
      modeRanges: modeRanges ?? this.modeRanges,
      names: names ?? this.names,
      ids: ids ?? this.ids,
    );
  }
}

// class ModesAvailableState extends ModesState {
//   final List<ModeInfo> modes;

//   ModesAvailableState({
//     required this.modes,
//   }) : super(null, null, null, null);
// }
