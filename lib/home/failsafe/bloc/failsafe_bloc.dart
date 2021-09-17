import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'failsafe_event.dart';
part 'failsafe_state.dart';

class FailsafeBloc extends Bloc<FailsafeEvent, FailsafeState> {
  FailsafeBloc() : super(FailsafeInitial());

  @override
  Stream<FailsafeState> mapEventToState(
    FailsafeEvent event,
  ) async* {}
}
