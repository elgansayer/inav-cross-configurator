part of 'home_bloc.dart';

class HomeState {
  final TabPage? tabPage;

  HomeState({
    this.tabPage,
  });

  factory HomeState.init() {
    return HomeState();
  }
}
