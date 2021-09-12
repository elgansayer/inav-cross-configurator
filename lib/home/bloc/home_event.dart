part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class ChangeHomePageEvent extends HomeEvent {
  final TabPage tabPage;

  ChangeHomePageEvent({required this.tabPage});
}
