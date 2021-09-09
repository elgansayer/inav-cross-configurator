import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:libserialport/libserialport.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late StreamSubscription<SerialPort?> _deviceListenrer;

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

    if (event is DisconnectEvent) {
      this.disconnect();
    }
  }

  _setupListeners() {
    this._deviceListenrer = _serialDeviceRepository.serialPortDevice
        .listen((SerialPort? serialPort) {
      if (serialPort != null && serialPort.isOpen) {
        this.add(ChangePageEvent(AppPage.home));
      } else {
        this.add(ChangePageEvent(AppPage.devices));
      }
    });
  }

  @override
  Future<void> close() {
    //cancel streams
    _deviceListenrer.cancel();
    this.disconnect();
    return super.close();
  }

  void disconnect() {
    _serialDeviceRepository.disconnect();
    this.add(ChangePageEvent(AppPage.devices));
  }
}
