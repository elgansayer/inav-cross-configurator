import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/components/bloc/errormessage_repository.dart';
import 'package:meta/meta.dart';

part 'errorbanner_event.dart';
part 'errorbanner_state.dart';

class ErrorBannerBloc extends Bloc<ErrorbannerEvent, ErrorBannerState> {
  final ErrorMessageRepository _errorMessageRepository;

  ErrorBannerBloc({required ErrorMessageRepository errorMessageRepository})
      : _errorMessageRepository = errorMessageRepository, super(ErrorBannerState.init()) {
    this.listenToErrors();
  }

  listenToErrors(){
    _errorMessageRepository.errors.listen((error) {
      this.add(AddMessageErrorBannerEvent(errorMessage: error));
    });
  }

  @override
  Stream<ErrorBannerState> mapEventToState(
    ErrorbannerEvent event,
  ) async* {
    if (event is AddMessageErrorBannerEvent) {
      yield ErrorBannerState.error(event.errorMessage);
    }

    if (event is CloseErrorBannerEvent) {
      yield ErrorBannerState.init();
    }
  }
}
