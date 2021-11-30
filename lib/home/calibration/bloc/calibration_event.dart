part of 'calibration_bloc.dart';

@immutable
abstract class CalibrationEvent {}

class GotMSPCalibrationData extends CalibrationEvent {
  GotMSPCalibrationData(this.calibrationData);

  final MSPCalibrationData calibrationData;
}

class ClearCalibrationData extends CalibrationEvent {
  ClearCalibrationData();
}

class FinishedCalibrationMode extends CalibrationEvent {
  FinishedCalibrationMode();
}

class StartAccCalibration extends CalibrationEvent {
  StartAccCalibration();
}
