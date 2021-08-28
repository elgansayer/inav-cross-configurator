part of 'app_bloc.dart';

enum AppPage { devices, home }

@immutable
class AppState {
  final AppPage appPage;

  AppState(this.appPage);
  factory AppState.init() => AppInitial();
}

class AppInitial extends AppState {
  AppInitial() : super(AppPage.devices);
}
