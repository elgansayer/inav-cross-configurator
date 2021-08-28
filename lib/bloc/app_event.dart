part of 'app_bloc.dart';

@immutable
abstract class AppEvent {
  factory AppEvent.changePage(AppPage appPage) {
    return new ChangePageEvent(appPage);
  }

  AppEvent();
}

class ChangePageEvent extends AppEvent {
  final AppPage appPage;
  ChangePageEvent(this.appPage);
}
