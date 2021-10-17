import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:inavconfigurator/msp/codes.dart';
import 'package:inavconfigurator/msp/codes/base_data_handler.dart';
import 'package:inavconfigurator/msp/codes/calibration_data.dart';
import 'package:inavconfigurator/serial/serialdevice_repository.dart';
import 'package:meta/meta.dart';

part 'calibration_event.dart';
part 'calibration_state.dart';

class CalibrationBloc extends Bloc<CalibrationEvent, CalibrationState> {
  CalibrationBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(CalibrationState.init()) {
    this._setupListeners();
  }

  final SerialDeviceRepository _serialDeviceRepository;
  late StreamSubscription<MSPDataHandler> _streamListener;

  @override
  Future<void> close() {
    this._streamListener.cancel();
    return super.close();
  }

  @override
  Stream<CalibrationState> mapEventToState(
    CalibrationEvent event,
  ) async* {
    if (event is GotMSPCalibrationData) {
      yield* _getCalibrationData(event.calibrationData);
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

    _writeModes();
  }

  void _writeModes() {
    try {
      _serialDeviceRepository.writeFunc(MSPCodes.mspCalibrationData);
    } catch (e) {
      this.close();
    }
  }

  Stream<CalibrationState> _getCalibrationData(
      MSPCalibrationData calibrationData) async* {
    List<AccCalibrationState> accCalibrationStates =
        calibrationData.acc.map((int e) {
      return AccCalibrationState(e == 1);
    }).toList();

    yield this.state.copyWith(
        accCalibrationStates: accCalibrationStates,
        calibrationData: calibrationData);
  }
}
