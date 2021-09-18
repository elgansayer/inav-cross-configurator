import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late StreamSubscription<SerialDeviceEvent> _deviceListenrer;

  AppBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(AppInitial()) {
    _setupListeners();
  }

  late SerialDeviceRepository _serialDeviceRepository;

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    // Setup listeners
    // if (event is AppInitEvent) {
    //   yield* mapAppInitialToState(event);
    // }

    if (event is ChangePageEvent) {
      yield AppState(event.appPage);
    }

    if (event is ReconnectEvent) {
      this._reconnect();
    }

    if (event is DisconnectEvent) {
      this._disconnect();
    }
  }

  _setupListeners() {
    this._deviceListenrer = _serialDeviceRepository.serialPortDevice
        .listen((SerialDeviceEvent serialDeviceEvent) {
      if (serialDeviceEvent.type == SerialDeviceEventType.connected) {
        this.add(ChangePageEvent(AppPage.home));
      } else if (serialDeviceEvent.type == SerialDeviceEventType.disconnected) {
        this._disconnect();
      } else {
        this.add(ChangePageEvent(AppPage.devices));
      }
    });
  }

  @override
  Future<void> close() {
    //cancel streams
    _deviceListenrer.cancel();
    this._disconnect();
    return super.close();
  }

  void _disconnect() {
    _serialDeviceRepository.disconnect();
    this.add(ChangePageEvent(AppPage.devices));
  }

  void _reconnect() {
    // Disconnect first
    _serialDeviceRepository.reconnect();

    // this.add(ChangePageEvent(AppPage.devices));
  }
}
