import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'errormessage_repository.dart';

part 'errorbanner_event.dart';
part 'errorbanner_state.dart';

class ErrorBannerBloc extends Bloc<ErrorbannerEvent, ErrorBannerState> {
  final ErrorMessageRepository _errorMessageRepository;

  ErrorBannerBloc({required ErrorMessageRepository errorMessageRepository})
      : _errorMessageRepository = errorMessageRepository,
        super(ErrorBannerState.init()) {
    on<AddMessageErrorBannerEvent>(
        (event, emit) => emit(ErrorBannerState.error(event.errorMessage)));
    on<CloseErrorBannerEvent>((event, emit) => emit(ErrorBannerState.init()));

    this.listenToErrors();
  }

  listenToErrors() {
    _errorMessageRepository.errors.listen((error) {
      this.add(AddMessageErrorBannerEvent(errorMessage: error));
    });
  }
}
