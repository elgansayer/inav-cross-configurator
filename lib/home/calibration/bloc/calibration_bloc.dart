import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:inavconfigurator/msp/codes.dart';
import 'package:inavconfigurator/msp/codes/base_data_handler.dart';
import 'package:inavconfigurator/msp/codes/calibration_data.dart';
import 'package:inavconfigurator/msp/writers/set_calibration_data.dart';
import 'package:inavconfigurator/serial/serialdevice_repository.dart';
import 'package:meta/meta.dart';

part 'calibration_event.dart';
part 'calibration_state.dart';

class CalibrationBloc extends Bloc<CalibrationEvent, CalibrationState> {
  late Timer _getDataTimer;

  CalibrationBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(CalibrationState.init()) {
    this._setupListeners();
    this._setupGetDatTimer();
  }

  final SerialDeviceRepository _serialDeviceRepository;
  late StreamSubscription<MSPDataHandler> _streamListener;

  @override
  Future<void> close() {
    this._getDataTimer.cancel();
    this._streamListener.cancel();
    return super.close();
  }

  @override
  Stream<CalibrationState> mapEventToState(
    CalibrationEvent event,
  ) async* {
    if (event is ClearCalibrationData) {
      yield* _clearCalibrationData();
    }

    if (event is GotMSPCalibrationData) {
      yield* _getCalibrationData(event.calibrationData);
    }

    if (event is StartAccCalibration) {
      yield* _startCalibrating();
    }

    if (event is FinishedCalibrationMode) {
      _setupGetDatTimer();
    }
  }

  void _setupListeners() {
    this._streamListener = _serialDeviceRepository.responseStreamsAs([
      MSPCodes.mspCalibrationData,
    ]).listen((messageResponse) {
      if (messageResponse is MSPCalibrationData) {
        this.add(GotMSPCalibrationData(messageResponse));
      }
    });
  }

  void _setupGetDatTimer() {
    this._getDataTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      _writeGetData();
    });
  }

  Stream<CalibrationState> _startCalibrating() async* {
    if (this._getDataTimer.isActive) {
      this._getDataTimer.cancel();
    }

    // Create an empty callibration
    SetCalibrationData setCalibrationData = SetCalibrationData(
        acc: List.generate(3, (index) => 0),
        accGain: Vector3.zero(),
        accZero: Vector3.zero(),
        magGain: Vector3.zero(),
        magZero: Vector3.zero(),
        opflowScale: 0);

    this.add(ClearCalibrationData());
    _serialDeviceRepository.writeBuilder(setCalibrationData);

    yield CalibrationState.init().copyWith(accCalibration: true);

    Future.delayed(Duration(seconds: 2), () {
      _doCalibrating();
    });
  }

  Future<void> _doCalibrating() async {
    if (this._getDataTimer.isActive) {
      this._getDataTimer.cancel();
    }

    while (!this.state.accCalibration) {
      if (!this.state.accCalibration) {
        break;
      }
      // this._setupGetDatTimer();
      _serialDeviceRepository.writeFunc(MSPCodes.mspResetConf);

      // this._setupGetDatTimer();
      _serialDeviceRepository.writeFunc(MSPCodes.mspAccCalibration);

      await Future.delayed(Duration(seconds: 2));

      _writeGetData();
      _doCalibrating();

      await Future.delayed(Duration(seconds: 2));
    }

    this.add(FinishedCalibrationMode());
  }

  void _writeGetData() {
    try {
      _serialDeviceRepository.writeFunc(MSPCodes.mspCalibrationData);
    } catch (e) {
      // this.close();
    }
  }

  Stream<CalibrationState> _clearCalibrationData() async* {
    List<AccCalibrationState> accCalibrationStates = this
        .state
        .accCalibrationStates
        .map((e) => AccCalibrationState(false))
        .toList();

    yield this.state.copyWith(
          accCalibrationStates: accCalibrationStates,
        );
  }

  Stream<CalibrationState> _getCalibrationData(
      MSPCalibrationData calibrationData) async* {
    List<AccCalibrationState> accCalibrationStates =
        calibrationData.acc.map((int e) {
      return AccCalibrationState(e == 1);
    }).toList();

    yield this.state.copyWith(
        accCalibration:
            !accCalibrationStates.every((state) => state.completed == true),
        accCalibrationStates: accCalibrationStates,
        calibrationData: calibrationData);
  }
}
