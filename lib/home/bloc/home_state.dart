part of 'home_bloc.dart';

class HomeState {
  final List<TabPage> tabPages;

  HomeState({
    required this.tabPages,
  });

  factory HomeState.init() {
    return HomeState(tabPages: []);
  }
}
