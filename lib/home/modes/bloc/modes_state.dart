part of 'modes_bloc.dart';

@immutable
abstract class ModesState {}

class ModesInitial extends ModesState {}

class ModesAvailableState extends ModesState {
  final List<ModeInfo> modes;

  ModesAvailableState({
    required this.modes,
  });
}
