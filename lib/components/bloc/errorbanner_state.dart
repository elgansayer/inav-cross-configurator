part of 'errorbanner_bloc.dart';

@immutable
class ErrorBannerState {
  ErrorBannerState({required this.errorMessage});

  factory ErrorBannerState.error(String message) =>
      new ErrorBannerState(errorMessage: message);

  factory ErrorBannerState.init() => new ErrorBannerState(errorMessage: "");

  final String errorMessage;

  bool get hasError => errorMessage.isNotEmpty;
}
