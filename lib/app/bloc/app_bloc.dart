import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:libserialport/libserialport.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late SerialDeviceRepository _serialDeviceRepository;

  AppBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(AppInitial());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    // Setup listeners
    if (event is AppInitEvent) {
      yield* mapAppInitialToState(event);
    }

    if (event is ChangePageEvent) {
      yield AppState(event.appPage);
    }
  }

  mapAppInitialToState(AppInitEvent event) async* {
    
    _serialDeviceRepository.serialPortDevice
        .listen((SerialPort? serialPort) async* {

      if (serialPort == null || serialPort.isOpen) {
        yield AppState(AppPage.home);
      } else {
        yield AppState(AppPage.devices);
      }
    });

    yield AppState.init();
  }
}
