import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../serial/serialdevice_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(AppInitial()) {
    on<ChangePageEvent>((event, emit) => emit(AppState(event.appPage)));
    on<ReconnectEvent>((event, emit) => this._reconnect());
    on<DisconnectEvent>((event, emit) => this._disconnect());
    _setupListeners();
  }

  late StreamSubscription<SerialDeviceEvent> _deviceListenrer;
  late SerialDeviceRepository _serialDeviceRepository;

  @override
  Future<void> close() {
    // Cancel streams
    _deviceListenrer.cancel();
    this._disconnect();
    return super.close();
  }

  _setupListeners() {
    this._deviceListenrer = _serialDeviceRepository.serialPortDevice
        .listen((SerialDeviceEvent serialDeviceEvent) {
      this._handleDeviceEvent(serialDeviceEvent);
    });
  }

  _handleDeviceEvent(SerialDeviceEvent serialDeviceEvent) {
    switch (serialDeviceEvent.type) {
      case SerialDeviceEventType.connected:
        this.add(ChangePageEvent(AppPage.home));
        break;
      case SerialDeviceEventType.connecting:
        this.add(ChangePageEvent(AppPage.devices));
        break;
      case SerialDeviceEventType.disconnected:
        this._disconnect();
        break;
      default:
        this.add(ChangePageEvent(AppPage.devices));
    }
  }

  void _disconnect() {
    _serialDeviceRepository.disconnect();
    this.add(ChangePageEvent(AppPage.devices));
  }

  void _reconnect() {
    // Disconnect first
    _serialDeviceRepository.reconnect();
    this.add(ChangePageEvent(AppPage.devices));
  }
}
