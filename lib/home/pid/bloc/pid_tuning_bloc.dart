import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pid_tuning_event.dart';
part 'pid_tuning_state.dart';

class PIDTuningBloc extends Bloc<PIDTuningEvent, PIDTuningState> {
  PIDTuningBloc() : super(PIDTuningInitial());

  @override
  Stream<PIDTuningState> mapEventToState(
    PIDTuningEvent event,
  ) async* {}
}
