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
    _setupListeners();
  }

  final ErrorMessageRepository _errorMessageRepository;
  final SerialDeviceRepository _serialDeviceRepository;
  final SerialPortRepository _serialPortRepository;

  @override
  Stream<DevicesPageState> mapEventToState(
    DevicesPageEvent event,
  ) async* {
    // Cancel
    if (event is FoundDevicesEvent) {
      yield new FoundDevicesState(event.serialPorts);
    }

    if (event is ConnectedDeviceEvent) {
      this._serialPortRepository.cancelPolling();
    }

    if (event is GetDevicesEvent) {
      this._serialPortRepository.startPolling();
    }

    // if (event is ErrorConnectionEvent) {
    //   List<SerialPortInfo> ports = state.serialPorts;
    //   String error = event.error;
    //   yield new ErrorConnectionState(error, ports);
    // }

    if (event is ConnectToDeviceEvent) {
      yield* _tryToConnect(event);
    }
  }

  Stream<DevicesPageState> _tryToConnect(ConnectToDeviceEvent event) async* {
    this._serialPortRepository.cancelPolling();

    SerialPortInfo serialPortInfo = event.serialPortInfo;
    yield new ConnectingState(state.serialPorts, serialPortInfo);

    // Clear any banners
    _errorMessageRepository.errorSink.add("");

    // Try and connect
    try {
      this._serialDeviceRepository.connect(serialPortInfo);
    } catch (e) {
      _errorMessageRepository.errorSink.add(e.toString());
    }
  }

  _setupListeners() {
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

    // Handle serial ports
    this._serialPortRepository.serialPorts.listen((serialPorts) {
      this.add(FoundDevicesEvent(serialPorts));
    });

    // Handle errors
    this._serialDeviceRepository.serialPortDeviceError.listen((error) {
      _errorMessageRepository.errorSink.add(error);

      this._serialDeviceRepository.disconnect();

      // Go back to ports view
      this.add(GetDevicesEvent());
    });
  }

  void dispose() {
    _serialPortRepository.dispose();
  }
}
