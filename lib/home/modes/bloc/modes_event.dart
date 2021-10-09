part of 'modes_bloc.dart';

@immutable
abstract class ModesEvent {}

class GotModesEvent extends ModesEvent {
  final List<ModeRange> modesRanges;
  GotModesEvent({
    required this.modesRanges,
  });
}

class GotBoxIdsEvent extends ModesEvent {
  final List<int> ids;
  GotBoxIdsEvent({
    required this.ids,
  });
}

class GotBoxNamesEvent extends ModesEvent {
  final List<String> names;
  GotBoxNamesEvent({
    required this.names,
  });
}

class GotAllDataEvent extends ModesEvent {
  GotAllDataEvent();
}
