import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'errormessage_repository.dart';

part 'errorbanner_event.dart';
part 'errorbanner_state.dart';

class ErrorBannerBloc extends Bloc<ErrorbannerEvent, ErrorBannerState> {
  ErrorBannerBloc({required ErrorMessageRepository errorMessageRepository})
      : _errorMessageRepository = errorMessageRepository,
        super(ErrorBannerState.init()) {
    on<AddMessageErrorBannerEvent>(
        (event, emit) => emit(ErrorBannerState.error(event.errorMessage)));
    on<CloseErrorBannerEvent>((event, emit) => emit(ErrorBannerState.init()));

    this.listenToErrors();
  }

  final ErrorMessageRepository _errorMessageRepository;

  listenToErrors() {
    _errorMessageRepository.errors.listen((error) {
      this.add(AddMessageErrorBannerEvent(errorMessage: error));
    });
  }
}
