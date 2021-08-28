part of 'devices_bloc.dart';

enum ConnectionScreenState { idle, connecting, connected }

@immutable
abstract class DevicesPageState {
  final List<SerialPortInfo> serialPorts;
  final ConnectionScreenState state;

  DevicesPageState(this.serialPorts, this.state);
}

class DevicesPageInitial extends DevicesPageState {
  DevicesPageInitial()
      : super(new List<SerialPortInfo>.empty(), ConnectionScreenState.idle);
}

class FoundDevicesState extends DevicesPageState {
  FoundDevicesState(List<SerialPortInfo> serialPorts)
      : super(serialPorts, ConnectionScreenState.idle);
}

class ConnectingState extends DevicesPageState {
  final SerialPortInfo serialPort;
  ConnectingState(List<SerialPortInfo> serialPorts, this.serialPort)
      : super(serialPorts, ConnectionScreenState.connecting);
}

class ConnectedState extends DevicesPageState {
  final SerialPortInfo serialPort;
  ConnectedState(List<SerialPortInfo> serialPorts, this.serialPort)
      : super(serialPorts, ConnectionScreenState.connected);
}

class ErrorConnectionState extends DevicesPageState {
  final String errorMessage;
  ErrorConnectionState(this.errorMessage, List<SerialPortInfo> serialPorts)
      : super(serialPorts, ConnectionScreenState.idle);
}
