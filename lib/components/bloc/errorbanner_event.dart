part of 'errorbanner_bloc.dart';

@immutable
abstract class ErrorbannerEvent {}

class CloseErrorBannerEvent extends ErrorbannerEvent {}

class AddMessageErrorBannerEvent extends ErrorbannerEvent {
  AddMessageErrorBannerEvent({required this.errorMessage});

  final String errorMessage;
}
