part of 'errorbanner_bloc.dart';

@immutable
abstract class ErrorbannerEvent {}

class CloseErrorBannerEvent extends ErrorbannerEvent {}

class AddMessageErrorBannerEvent extends ErrorbannerEvent {
  final String errorMessage;
  AddMessageErrorBannerEvent({required this.errorMessage});
}
