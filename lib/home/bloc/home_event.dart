part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class ChangeHomePageEvent extends HomeEvent {
  ChangeHomePageEvent({required this.tabPage});

  final TabPage tabPage;
}
