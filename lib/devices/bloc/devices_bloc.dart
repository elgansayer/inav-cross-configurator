import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../components/bloc/errormessage_repository.dart';
import '../../serial/serialdevice_repository.dart';
import '../../serial/serialport_model.dart';
import '../../serial/serialport_repository.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesPageBloc extends Bloc<DevicesPageEvent, DevicesPageState> {
  late StreamSubscription<SerialDeviceEvent> _serialDeviceListenr;
  late StreamSubscription<List<SerialPortInfo>> _serialPortListener;
  late StreamSubscription<String> _errorListener;

  DevicesPageBloc(
      {required ErrorMessageRepository errorMessageRepository,
      required SerialPortRepository serialPortRepository,
      required SerialDeviceRepository serialDeviceRepository})
      : _serialPortRepository = serialPortRepository,
        _errorMessageRepository = errorMessageRepository,
        _serialDeviceRepository = serialDeviceRepository,
        super(DevicesPageInitial()) {
    // Ensure we are disconnected

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
      // this._serialDeviceRepository.readListen();
    } catch (e) {
      print(e);
      _errorMessageRepository.errorSink.add(e.toString());
      this.add(GetDevicesEvent());
    }
  }

  _setupListeners() {
    // Handle connected
    this._serialDeviceListenr = this
        ._serialDeviceRepository
        .serialPortDevice
        .listen((SerialDeviceEvent serialDeviceEvent) {
      if (serialDeviceEvent.type == SerialDeviceEventType.connected) {
        this.add(ConnectedDeviceEvent());
      }
    });

    // Handle serial ports
    this._serialPortListener =
        this._serialPortRepository.serialPorts.listen((serialPorts) {
      this.add(FoundDevicesEvent(serialPorts));
    });

    // Handle errors
    this._errorListener =
        this._serialDeviceRepository.serialPortDeviceError.listen((error) {
      _errorMessageRepository.errorSink.add(error);
      // Go back to ports view
      this.add(GetDevicesEvent());
      this._serialDeviceRepository.disconnect();
    });
  }

  @override
  Future<void> close() {
    //cancel streams
    this._errorListener.cancel();
    this._serialPortListener.cancel();
    this._serialDeviceListenr.cancel();
    _serialPortRepository.close();
    return super.close();
  }
}
