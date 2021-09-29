part of 'modes_bloc.dart';

@immutable
abstract class ModesEvent {}

class GotModesEvent extends ModesEvent {
  final List<ModeRange> modesRanges;
  GotModesEvent({
    required this.modesRanges,
  });
}
