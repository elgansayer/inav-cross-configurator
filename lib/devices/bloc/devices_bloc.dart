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
  DevicesPageBloc(
      {required ErrorMessageRepository errorMessageRepository,
      required SerialPortRepository serialPortRepository,
      required SerialDeviceRepository serialDeviceRepository})
      : _serialPortRepository = serialPortRepository,
        _errorMessageRepository = errorMessageRepository,
        _serialDeviceRepository = serialDeviceRepository,
        super(DevicesPageInitial()) {
    // Ensure we are disconnected
    on<FoundDevicesEvent>((event, emit) {
      emit(new FoundDevicesState(event.serialPorts));
    });
    on<ConnectedDeviceEvent>((event, emit) {
      this._serialPortRepository.cancelPolling();
    });
    on<GetDevicesEvent>((event, emit) {
      this._serialPortRepository.startPolling();
    });
    on<ConnectToDeviceEvent>((event, emit) => this._tryToConnect(event, emit));

    _setupListeners();
  }

  late StreamSubscription<String> _errorListener;
  final ErrorMessageRepository _errorMessageRepository;
  late StreamSubscription<SerialDeviceEvent> _serialDeviceListenr;
  final SerialDeviceRepository _serialDeviceRepository;
  late StreamSubscription<List<SerialPortInfo>> _serialPortListener;
  final SerialPortRepository _serialPortRepository;

  @override
  Future<void> close() {
    //cancel streams
    this._errorListener.cancel();
    this._serialPortListener.cancel();
    this._serialDeviceListenr.cancel();
    _serialPortRepository.close();
    return super.close();
  }

  void _tryToConnect(
      ConnectToDeviceEvent event, Emitter<DevicesPageState> emit) {
    this._serialPortRepository.cancelPolling();

    SerialPortInfo serialPortInfo = event.serialPortInfo;
    emit(new ConnectingState(state.serialPorts, serialPortInfo));

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
}
