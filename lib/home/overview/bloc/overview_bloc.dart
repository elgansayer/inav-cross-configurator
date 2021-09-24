import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:inavconfigurator/msp/codes.dart';
import 'package:inavconfigurator/msp/codes/status_ex.dart';
import 'package:inavconfigurator/msp/mspmessage.dart';
import 'package:inavconfigurator/serial/serialdevice_repository.dart';
import 'package:meta/meta.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  late StreamSubscription<MSPMessageResponse> _streamListener;

  InfoBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(InfoInitial()) {
    _setupListeners();
  }

  final SerialDeviceRepository _serialDeviceRepository;

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {}

  _setupListeners() {
    this._streamListener = _serialDeviceRepository
        .responseStreams(MSPCodes.mspStatusEx)
        .listen((messageResponse) {
      MSPStatusEx? rawImu = _serialDeviceRepository.transform(
          MSPCodes.mspStatusEx, messageResponse);

      if (rawImu == null) {
        return;
      }
    });

    _sendRequest();
  }

  @override
  Future<void> close() {
    //cancel streams
    this._streamListener.cancel();
    return super.close();
  }

  Future<void> _sendRequest() async {
    try {
      _serialDeviceRepository.writeFunc(MSPCodes.mspStatusEx);
    } catch (e) {
      this.close();
    }
  }
}

class BetterInfo {
  // Battery detected cell count
  final int detectedCellCount;
  // Battery voltage:
  final int voltage;
  // Battery left
  final int left;
  // Battery remaining capacity
  final int remainingCapacity;
  // Battery full when plugged in
  final bool fullWhenPluggedIn;
  // Battery use cap thresholds
  final bool useCapThresholds;
  // Current draw
  final int currentDraw;
  // Power draw:
  final int powerDraw;
  // Capacity drawn: mah
  final int capacityDrawnMah;
  // Capacity drawn: wh
  final int capacityDrawnWh;
  // RSSI
  final int rssi;

  BetterInfo(
      {required this.detectedCellCount,
      required this.voltage,
      required this.left,
      required this.remainingCapacity,
      required this.fullWhenPluggedIn,
      required this.useCapThresholds,
      required this.currentDraw,
      required this.powerDraw,
      required this.capacityDrawnMah,
      required this.capacityDrawnWh,
      required this.rssi});
}

// Pre-arming checks
class PreArmChecks {
  // UAV is levelled
  final bool levelled;
  // Run-time calibration
  final bool runTimeCalibration;
  // CPU load
  final bool cpuLoad;
  // Navigation is safe
  final bool navigationSafe;
  // Compass calibrated
  final bool compassCalibrated;
  // Accelerometer calibrated
  final bool accelerometerCalibrated;
  // Settings validated
  final bool validated;
  // Hardware health
  final bool hardwareHealth;

  PreArmChecks({
    required this.levelled,
    required this.runTimeCalibration,
    required this.cpuLoad,
    required this.navigationSafe,
    required this.compassCalibrated,
    required this.accelerometerCalibrated,
    required this.validated,
    required this.hardwareHealth,
  });
}

//
class GpsInfo {
// GPS
// Fix type:
// Sats:
// Latitude:
// Longitude:
}
