part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}


class StateA extends HomeInitial {}

class StateB extends HomeInitial {}