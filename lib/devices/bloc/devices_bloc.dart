import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/components/bloc/errormessage_repository.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';
import 'package:inavconfiurator/serial/serialport_repository.dart';
import 'package:libserialport/libserialport.dart';
import 'package:meta/meta.dart';

part 'devices_state.dart';
part 'devices_event.dart';

class DevicesPageBloc extends Bloc<DevicesPageEvent, DevicesPageState> {
  DevicesPageBloc(
      {required ErrorMessageRepository errorMessageRepository,
      required SerialPortRepository serialPortRepository,
      required SerialDeviceRepository serialDeviceRepository})
      : _serialPortRepository = serialPortRepository,
        _errorMessageRepository = errorMessageRepository,
        _serialDeviceRepository = serialDeviceRepository,
        super(DevicesPageInitial()) {
    listenToSerialPorts();
  }

  final ErrorMessageRepository _errorMessageRepository;
  final SerialDeviceRepository _serialDeviceRepository;
  final SerialPortRepository _serialPortRepository;

  @override
  Stream<DevicesPageState> mapEventToState(
    DevicesPageEvent event,
  ) async* {
    if (event is GetDevicesEvent) {
      List<SerialPortInfo> ports = this._serialPortRepository.ports;
      yield new FoundDevicesState(ports);
    }

    if (event is ErrorConnectionEvent) {
      List<SerialPortInfo> ports = state.serialPorts;
      String error = event.error;
      yield new ErrorConnectionState(error, ports);
    }

    if (event is ConnectToDeviceEvent) {
      SerialPortInfo serialPortInfo = event.serialPortInfo;
      yield new ConnectingState(state.serialPorts, serialPortInfo);

      // Clear any banners
      // Now done through the bloc in UI
      _errorMessageRepository.errorSink.add("");

      // Try and connect
      this._serialDeviceRepository.connect(serialPortInfo);
    }
  }

  listenToSerialPorts() {
    // Handle connected
    this
        ._serialDeviceRepository
        .serialPortDevice
        .listen((SerialPort? serialPort) {
      if (serialPort == null) {
        return;
      }

      this.add(ConnectedDeviceEvent());
    });

    // Handle errors
    this._serialDeviceRepository.serialPortDeviceError.listen((error) {
      _errorMessageRepository.errorSink.add(error);

      // Go back to ports view
      this.add(GetDevicesEvent());
    });
  }
}
