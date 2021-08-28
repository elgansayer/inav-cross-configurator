part of 'devices_bloc.dart';

@immutable
abstract class DevicesPageEvent {
  factory DevicesPageEvent.getPorts() {
    return new GetDevicesEvent();
  }

  factory DevicesPageEvent.connectToDeviceEvent(SerialPortInfo serialPortInfo) {
    return new ConnectToDeviceEvent(serialPortInfo);
  }
  DevicesPageEvent();
}

class GetDevicesEvent extends DevicesPageEvent {}
class ConnectToDeviceEvent extends DevicesPageEvent {
  final SerialPortInfo serialPortInfo;
  ConnectToDeviceEvent(this.serialPortInfo);
}

class ConnectedDeviceEvent extends DevicesPageEvent {
  ConnectedDeviceEvent();
}

class ErrorConnectionEvent extends DevicesPageEvent {
  final String error;
  ErrorConnectionEvent(this.error);
}
