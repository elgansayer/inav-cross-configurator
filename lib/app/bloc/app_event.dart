part of 'app_bloc.dart';

@immutable
abstract class AppEvent {

  factory AppEvent.setup() {
    return new AppInitEvent();
  }

  factory AppEvent.changePage(AppPage appPage) {
    return new ChangePageEvent(appPage);
  }

  AppEvent();
}

class AppInitEvent extends AppEvent {
  AppInitEvent();
}

class ChangePageEvent extends AppEvent {
  final AppPage appPage;
  ChangePageEvent(this.appPage);
}
