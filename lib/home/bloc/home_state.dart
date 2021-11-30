part of 'home_bloc.dart';

class HomeState {
  HomeState({
    this.tabPage,
  });

  factory HomeState.init() {
    return HomeState();
  }

  final TabPage? tabPage;
}
