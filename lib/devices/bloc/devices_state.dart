part of 'devices_bloc.dart';

enum ConnectionScreenState { idle, connecting, connected }

@immutable
abstract class DevicesPageState {
  DevicesPageState(this.serialPorts, this.state);

  final List<SerialPortInfo> serialPorts;
  final ConnectionScreenState state;
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
  ConnectingState(List<SerialPortInfo> serialPorts, this.serialPort)
      : super(serialPorts, ConnectionScreenState.connecting);

  final SerialPortInfo serialPort;
}

class ConnectedState extends DevicesPageState {
  ConnectedState(List<SerialPortInfo> serialPorts, this.serialPort)
      : super(serialPorts, ConnectionScreenState.connected);

  final SerialPortInfo serialPort;
}

class ErrorConnectionState extends DevicesPageState {
  ErrorConnectionState(this.errorMessage, List<SerialPortInfo> serialPorts)
      : super(serialPorts, ConnectionScreenState.idle);

  final String errorMessage;
}
