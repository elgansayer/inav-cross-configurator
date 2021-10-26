part of 'calibration_bloc.dart';

@immutable
abstract class CalibrationEvent {}

class GotMSPCalibrationData extends CalibrationEvent {
  final MSPCalibrationData calibrationData;

  GotMSPCalibrationData(this.calibrationData);
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
