import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cli_event.dart';
part 'cli_state.dart';

class CliBloc extends Bloc<CliEvent, CliState> {
  CliBloc() : super(CliInitial());

  @override
  Stream<CliState> mapEventToState(
    CliEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
