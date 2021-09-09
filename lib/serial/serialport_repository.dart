import 'dart:async';

import 'package:inavconfiurator/serial/serialport_model.dart';

import 'serialport_provider.dart';

class SerialPortRepository {
  final SerialPortProvider _serialPortsProvider = SerialPortProvider();
  Timer? _timer;

  SerialPortRepository();

  final _serialPortsStreamController =
      StreamController<List<SerialPortInfo>>.broadcast();

  StreamSink<List<SerialPortInfo>> get _serialPortsSink =>
      _serialPortsStreamController.sink;

  Stream<List<SerialPortInfo>> get serialPorts =>
      _serialPortsStreamController.stream;

  _updatePorts() {
    var ports = _serialPortsProvider.ports;
    _serialPortsSink.add(ports);
  }

  startPolling() {
    const oneSec = Duration(seconds: 1);
    this._timer = Timer.periodic(oneSec, (Timer t) => _updatePorts());
  }

  void close() {
    this.cancelPolling();
    _serialPortsStreamController.close();
  }

  void cancelPolling() {
    if (this._timer != null) {
      this._timer!.cancel();
    }
  }
}
