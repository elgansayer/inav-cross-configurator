part of 'errorbanner_bloc.dart';

@immutable
class ErrorBannerState {
  bool get hasError => errorMessage.isNotEmpty;
  final String errorMessage;

  ErrorBannerState({required this.errorMessage});

  factory ErrorBannerState.init() => new ErrorBannerState(errorMessage: "");
  factory ErrorBannerState.error(String message) =>
      new ErrorBannerState(errorMessage: message);
}
