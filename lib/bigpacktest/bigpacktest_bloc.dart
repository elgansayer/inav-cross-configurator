import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/bigpacktest/index.dart';

class BigpacktestBloc extends Bloc<BigpacktestEvent, BigpacktestState> {

  BigpacktestBloc(BigpacktestState initialState) : super(initialState);

  @override
  Stream<BigpacktestState> mapEventToState(
    BigpacktestEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'BigpacktestBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
