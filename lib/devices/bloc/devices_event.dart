part of 'devices_bloc.dart';

@immutable
abstract class DevicesPageEvent {
  DevicesPageEvent();

  factory DevicesPageEvent.connectToDeviceEvent(SerialPortInfo serialPortInfo) {
    return new ConnectToDeviceEvent(serialPortInfo);
  }

  factory DevicesPageEvent.getPorts() {
    return new GetDevicesEvent();
  }
}

class GetDevicesEvent extends DevicesPageEvent {}

class FoundDevicesEvent extends DevicesPageEvent {
  FoundDevicesEvent(this.serialPorts);

  final List<SerialPortInfo> serialPorts;
}

class ConnectToDeviceEvent extends DevicesPageEvent {
  ConnectToDeviceEvent(this.serialPortInfo);

  final SerialPortInfo serialPortInfo;
}

class ConnectedDeviceEvent extends DevicesPageEvent {
  ConnectedDeviceEvent();
}

class ErrorConnectionEvent extends DevicesPageEvent {
  ErrorConnectionEvent(this.error);

  final String error;
}
