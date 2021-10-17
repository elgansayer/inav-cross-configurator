part of 'calibration_bloc.dart';

class AccCalibrationState {
  final bool completed;
  AccCalibrationState(this.completed);
}

class CalibrationState {
  CalibrationState({
    required this.calibrationData,
    required this.accCalibrationStates,
  });

  factory CalibrationState.init() {
    return CalibrationState(
        calibrationData: null,
        accCalibrationStates:
            List.generate(6, (index) => AccCalibrationState(false)));
  }

  MSPCalibrationData? calibrationData;
  List<AccCalibrationState> accCalibrationStates;

  CalibrationState copyWith({
    MSPCalibrationData? calibrationData,
    List<AccCalibrationState>? accCalibrationStates,
  }) {
    return CalibrationState(
      calibrationData: calibrationData ?? this.calibrationData,
      accCalibrationStates: accCalibrationStates ?? this.accCalibrationStates,
    );
  }
}
