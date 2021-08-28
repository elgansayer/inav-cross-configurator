import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';
import 'package:inavconfiurator/serial/serialport_repository.dart';
import 'package:meta/meta.dart';

part 'devices_state.dart';
part 'devices_event.dart';

class DevicesPageBloc
    extends Bloc<DevicesPageEvent, DevicesPageState> {
  DevicesPageBloc(
      {required SerialPortRepository serialPortRepository,
      required SerialDeviceRepository serialDeviceRepository})
      : super(DevicesPageInitial()) {
    this._serialPortRepository = serialPortRepository;
    this._serialDeviceRepository = serialDeviceRepository;
  }

  late SerialDeviceRepository _serialDeviceRepository;
  late SerialPortRepository _serialPortRepository;

  @override
  Stream<DevicesPageState> mapEventToState(
    DevicesPageEvent event,
  ) async* {
    if (event is GetPortsEvent) {
      List<SerialPortInfo> ports = this._serialPortRepository.ports;
      yield new FoundDevicesState(ports);
    }

    if (event is ConnectToDeviceEvent) {
      SerialPortInfo serialPortInfo = event.serialPortInfo;
      yield new ConnectingState(state.serialPorts, serialPortInfo);

      bool opened = this._serialDeviceRepository.connect(serialPortInfo);

      if (opened) {
        yield new ConnectedState(state.serialPorts, serialPortInfo);
      }
    }
  }
}
