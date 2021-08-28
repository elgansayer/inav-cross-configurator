part of 'devices_bloc.dart';

@immutable
abstract class DevicesPageEvent {
  factory DevicesPageEvent.getPorts() {
    return new GetPortsEvent();
  }

  factory DevicesPageEvent.gotPorts() {
    return new GotPortsEvent();
  }

  factory DevicesPageEvent.connectToDeviceEvent(
      SerialPortInfo serialPortInfo) {
    return new ConnectToDeviceEvent(serialPortInfo);
  }
  DevicesPageEvent();
}

class GetPortsEvent extends DevicesPageEvent {}

class GotPortsEvent extends DevicesPageEvent {}

class ConnectToDeviceEvent extends DevicesPageEvent {
  final SerialPortInfo serialPortInfo;
  ConnectToDeviceEvent(this.serialPortInfo);
}

class ConnectedDeviceEvent extends DevicesPageEvent {
  final SerialPortInfo serialPortInfo;
  ConnectedDeviceEvent(this.serialPortInfo);
}
