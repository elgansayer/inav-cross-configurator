import 'dart:async';
import 'dart:developer' as developer;

import 'package:inavconfiurator/bigpacktest/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BigpacktestEvent {
  Stream<BigpacktestState> applyAsync(
      {BigpacktestState currentState, BigpacktestBloc bloc});
}

class UnBigpacktestEvent extends BigpacktestEvent {
  @override
  Stream<BigpacktestState> applyAsync({BigpacktestState? currentState, BigpacktestBloc? bloc}) async* {
    yield UnBigpacktestState();
  }
}

class LoadBigpacktestEvent extends BigpacktestEvent {
   
  @override
  Stream<BigpacktestState> applyAsync(
      {BigpacktestState? currentState, BigpacktestBloc? bloc}) async* {
    try {
      yield UnBigpacktestState();
      await Future.delayed(const Duration(seconds: 1));
      yield InBigpacktestState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadBigpacktestEvent', error: _, stackTrace: stackTrace);
      yield ErrorBigpacktestState( _.toString());
    }
  }
}
