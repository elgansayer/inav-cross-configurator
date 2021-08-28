import 'dart:async';

class ErrorMessageRepository {
  ErrorMessageRepository();

  final _errorStreamController = StreamController<String>();

  StreamSink<String> get errorSink => _errorStreamController.sink;
  Stream<String> get errors => _errorStreamController.stream;

  dispose() {
    _errorStreamController.close();
  }
}
