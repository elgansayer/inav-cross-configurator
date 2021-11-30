part of 'app_bloc.dart';

@immutable
abstract class AppEvent {
  AppEvent();

  factory AppEvent.changePage(AppPage appPage) {
    return new ChangePageEvent(appPage);
  }

  factory AppEvent.setup() {
    return new AppInitEvent();
  }
}

class AppInitEvent extends AppEvent {
  AppInitEvent();
}

class ChangePageEvent extends AppEvent {
  ChangePageEvent(this.appPage);

  final AppPage appPage;
}

class DisconnectEvent extends AppEvent {
  DisconnectEvent();
}

class ReconnectEvent extends AppEvent {
  ReconnectEvent();
}
