part of 'calibration_bloc.dart';

class AccCalibrationState {
  AccCalibrationState(this.completed);

  final bool completed;
}

class CalibrationState {
  CalibrationState({
    required this.calibrationData,
    required this.accCalibrationStates,
    required this.accCalibration,
  });

  factory CalibrationState.init() {
    return CalibrationState(
        calibrationData: null,
        accCalibration: false,
        accCalibrationStates:
            List.generate(6, (index) => AccCalibrationState(false)));
  }

  bool accCalibration;
  List<AccCalibrationState> accCalibrationStates;
  MSPCalibrationData? calibrationData;

  CalibrationState copyWith({
    MSPCalibrationData? calibrationData,
    bool? accCalibration,
    List<AccCalibrationState>? accCalibrationStates,
  }) {
    return CalibrationState(
      accCalibration: accCalibration ?? this.accCalibration,
      calibrationData: calibrationData ?? this.calibrationData,
      accCalibrationStates: accCalibrationStates ?? this.accCalibrationStates,
    );
  }
}
