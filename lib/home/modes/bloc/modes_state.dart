part of 'modes_bloc.dart';

@immutable
abstract class ModesState {}

class ModesInitial extends ModesState {}

class ModesAvailable extends ModesState {
  final List<ModeInfo> modes;

  ModesAvailable({
    required this.modes,
  });
}
