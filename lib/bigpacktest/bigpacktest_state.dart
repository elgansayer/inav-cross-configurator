import 'package:equatable/equatable.dart';

abstract class BigpacktestState extends Equatable {
  BigpacktestState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnBigpacktestState extends BigpacktestState {

  UnBigpacktestState();

  @override
  String toString() => 'UnBigpacktestState';
}

/// Initialized
class InBigpacktestState extends BigpacktestState {
  InBigpacktestState(this.hello);
  
  final String hello;

  @override
  String toString() => 'InBigpacktestState $hello';

  @override
  List<Object> get props => [hello];
}

class ErrorBigpacktestState extends BigpacktestState {
  ErrorBigpacktestState(this.errorMessage);
 
  final String errorMessage;
  
  @override
  String toString() => 'ErrorBigpacktestState';

  @override
  List<Object> get props => [errorMessage];
}
