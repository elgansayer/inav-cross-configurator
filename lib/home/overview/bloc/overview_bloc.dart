import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:inavconfigurator/msp/codes.dart';
import 'package:inavconfigurator/msp/codes/inav_status.dart';
import 'package:inavconfigurator/msp/msp_message.dart';
import 'package:inavconfigurator/serial/serialdevice_repository.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  late StreamSubscription<MSPMessageResponse> _streamListener;

  InfoBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(InfoState.init());

  final SerialDeviceRepository _serialDeviceRepository;

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
    if (event is GotStatusEvent) {
      yield* _mapGotStatusEvent(event.inavStatus);
    }
  }

  _setupListeners() {
    this._streamListener = _serialDeviceRepository
        .responseStreams(MSPCodes.mspv2InavStatus)
        .listen((messageResponse) {
      // Get the status from the response
      MSPINavStatus? inavStatus = _serialDeviceRepository.transform(
          MSPCodes.mspv2InavStatus, messageResponse);

      if (inavStatus == null) {
        return;
      }

      this.add(GotStatusEvent(inavStatus: inavStatus));
    });

    // _serialDeviceRepository.responseRaw.listen((Uint8List data) {
    //   if (data == data) {
    //     return;
    //   }
    // });

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
      _serialDeviceRepository.writeFunc(MSPCodes.mspv2InavStatus);
    } catch (e) {
      print(e);
      this.close();
    }
  }

  Stream<InfoState> _mapGotStatusEvent(MSPINavStatus inavStatus) async* {
    var allFlags = ArmFlags.allFlags;
    var armingFlags = inavStatus.armingFlags;

    // Go through each flag and create a list if they are enabled
    Iterable<ArmFlag> preArmChecks = allFlags.map((ArmFlag armFlag) {
      return armFlag.copyWith(enabled: armFlag.isEnabled(armingFlags));
    }).toList();

    yield InfoState.gotStatus(inavStatus: inavStatus, armFlags: preArmChecks);
  }
}

class ArmFlag {
  final String name;
  final ArmIds id;
  final int flag;
  final bool enabled;

  ArmFlag({
    required this.id,
    required this.flag,
    required this.name,
    required this.enabled,
  });

  bool isEnabled(int armingFlags) {
    return ((armingFlags >> this.flag) % 2 != 0);
  }

  ArmFlag copyWith({
    String? name,
    ArmIds? id,
    int? flag,
    bool? enabled,
  }) {
    return ArmFlag(
      name: name ?? this.name,
      id: id ?? this.id,
      flag: flag ?? this.flag,
      enabled: enabled ?? this.enabled,
    );
  }
}

enum ArmIds {
  OkToArm,
  PreventArming,
  Armed,
  WasEverArmed,
  BlockedUAVNotLevel,
  BlockedSensorsCalibrating,
  BlockedSystemOverloaded,
  BlockedNavigationSafety,
  BlockedCompassNotCalibrated,
  BlockedAccelerometerNotCalibrated,
  None,
  BlockedHardwareFailure,
  BlockedInvalidSetting,
}

class ArmFlags {
  static const OkToArm = 0;
  static const PreventArming = 1;
  static const Armed = 2;
  static const WasEverArmed = 3;
  static const BlockedUAVNotLevel = 8;
  static const BlockedSensorsCalibrating = 9;
  static const BlockedSystemOverloaded = 10;
  static const BlockedNavigationSafety = 11;
  static const BlockedCompassNotCalibrated = 12;
  static const BlockedAccelerometerNotCalibrated = 13;
  static const None = 14;
  static const BlockedHardwareFailure = 15;
  static const BlockedInvalidSetting = 26;

  // Names for translation
  static Map<ArmIds, String> names = {
    ArmIds.OkToArm: 'OkToArm',
    ArmIds.PreventArming: 'PreventArming',
    ArmIds.Armed: 'Armed',
    ArmIds.WasEverArmed: 'WasEverArmed',
    ArmIds.BlockedUAVNotLevel: 'BlockedUAVNotLevel',
    ArmIds.BlockedSensorsCalibrating: 'BlockedSensorsCalibrating',
    ArmIds.BlockedSystemOverloaded: 'BlockedSystemOverloaded',
    ArmIds.BlockedNavigationSafety: 'BlockedNavigationSafety',
    ArmIds.BlockedCompassNotCalibrated: 'BlockedCompassNotCalibrated',
    ArmIds.BlockedAccelerometerNotCalibrated:
        'BlockedAccelerometerNotCalibrated',
    ArmIds.None: 'None',
    ArmIds.BlockedHardwareFailure: 'BlockedHardwareFailure',
    ArmIds.BlockedInvalidSetting: 'BlockedInvalidSetting',
  };

  static String name(ArmIds id) {
    return ArmFlags.names[id] ?? '';
  }

  static List<ArmFlag> allFlags = [
    // ArmFlag(flag: , name: 'OkToArm'),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.OkToArm),
        id: ArmIds.OkToArm,
        flag: ArmFlags.OkToArm),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.PreventArming),
        id: ArmIds.PreventArming,
        flag: ArmFlags.PreventArming),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.Armed),
        id: ArmIds.Armed,
        flag: ArmFlags.Armed),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.WasEverArmed),
        id: ArmIds.WasEverArmed,
        flag: ArmFlags.WasEverArmed),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.BlockedUAVNotLevel),
        id: ArmIds.BlockedUAVNotLevel,
        flag: ArmFlags.BlockedUAVNotLevel),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.BlockedSensorsCalibrating),
        id: ArmIds.BlockedSensorsCalibrating,
        flag: ArmFlags.BlockedSensorsCalibrating),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.BlockedSystemOverloaded),
        id: ArmIds.BlockedSystemOverloaded,
        flag: ArmFlags.BlockedSystemOverloaded),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.BlockedNavigationSafety),
        id: ArmIds.BlockedNavigationSafety,
        flag: ArmFlags.BlockedNavigationSafety),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.BlockedCompassNotCalibrated),
        id: ArmIds.BlockedCompassNotCalibrated,
        flag: ArmFlags.BlockedCompassNotCalibrated),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.BlockedAccelerometerNotCalibrated),
        id: ArmIds.BlockedAccelerometerNotCalibrated,
        flag: ArmFlags.BlockedAccelerometerNotCalibrated),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.None),
        id: ArmIds.None,
        flag: ArmFlags.None),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.BlockedHardwareFailure),
        id: ArmIds.BlockedHardwareFailure,
        flag: ArmFlags.BlockedHardwareFailure),
    ArmFlag(
        enabled: false,
        name: ArmFlags.name(ArmIds.BlockedInvalidSetting),
        id: ArmIds.BlockedInvalidSetting,
        flag: ArmFlags.BlockedInvalidSetting),
  ];
}

// class BetterInfo {
//   // Battery detected cell count
//   final int detectedCellCount;
//   // Battery voltage:
//   final int voltage;
//   // Battery left
//   final int left;
//   // Battery remaining capacity
//   final int remainingCapacity;
//   // Battery full when plugged in
//   final bool fullWhenPluggedIn;
//   // Battery use cap thresholds
//   final bool useCapThresholds;
//   // Current draw
//   final int currentDraw;
//   // Power draw:
//   final int powerDraw;
//   // Capacity drawn: mah
//   final int capacityDrawnMah;
//   // Capacity drawn: wh
//   final int capacityDrawnWh;
//   // RSSI
//   final int rssi;

//   BetterInfo(
//       {required this.detectedCellCount,
//       required this.voltage,
//       required this.left,
//       required this.remainingCapacity,
//       required this.fullWhenPluggedIn,
//       required this.useCapThresholds,
//       required this.currentDraw,
//       required this.powerDraw,
//       required this.capacityDrawnMah,
//       required this.capacityDrawnWh,
//       required this.rssi});
// }

// // Pre-arming checks
// class PreArmChecks {
//   // UAV is levelled
//   final bool levelled;
//   // Run-time calibration
//   final bool runTimeCalibration;
//   // CPU load
//   final bool cpuLoad;
//   // Navigation is safe
//   final bool navigationSafe;
//   // Compass calibrated
//   final bool compassCalibrated;
//   // Accelerometer calibrated
//   final bool accelerometerCalibrated;
//   // Settings validated
//   final bool validated;
//   // Hardware health
//   final bool hardwareHealth;

//   PreArmChecks({
//     required this.levelled,
//     required this.runTimeCalibration,
//     required this.cpuLoad,
//     required this.navigationSafe,
//     required this.compassCalibrated,
//     required this.accelerometerCalibrated,
//     required this.validated,
//     required this.hardwareHealth,
//   });
// }

// //
// class GpsInfo {
// // GPS
// // Fix type:
// // Sats:
// // Latitude:
// // Longitude:
// }
