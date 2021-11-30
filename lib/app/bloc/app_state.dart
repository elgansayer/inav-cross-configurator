part of 'app_bloc.dart';

enum AppPage { devices, home }

@immutable
class AppState {
  AppState(this.appPage);

  factory AppState.init() => AppInitial();

  final AppPage appPage;
}

class AppInitial extends AppState {
  AppInitial() : super(AppPage.devices);
}
