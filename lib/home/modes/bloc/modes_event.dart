part of 'modes_bloc.dart';

@immutable
abstract class ModesEvent {}

class GotModesEvent extends ModesEvent {
  GotModesEvent({
    required this.modesRanges,
  });

  final List<ModeRange> modesRanges;
}

class GotBoxIdsEvent extends ModesEvent {
  GotBoxIdsEvent({
    required this.ids,
  });

  final List<int> ids;
}

class GotBoxNamesEvent extends ModesEvent {
  GotBoxNamesEvent({
    required this.names,
  });

  final List<String> names;
}

class GotAllDataEvent extends ModesEvent {
  GotAllDataEvent();
}

class GeneratedModeInfoEvent extends ModesEvent {
  GeneratedModeInfoEvent({
    required this.modes,
  });

  final List<ModeInfo> modes;
}

class AddNewModesEvent extends ModesEvent {
  AddNewModesEvent({
    required this.modes,
  });

  final List<ModeInfo> modes;
}

class RemoveModeEvent extends ModesEvent {
  RemoveModeEvent({
    required this.mode,
  });

  final ModeInfo mode;
}
