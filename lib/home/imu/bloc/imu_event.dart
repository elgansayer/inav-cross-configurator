part of 'imu_bloc.dart';

@immutable
abstract class ImuViewEvent {}

class ImuAdd3DObjectEvent extends ImuViewEvent {
  ImuAdd3DObjectEvent(this.mdlObject);

  final Object mdlObject;
}

class ImuAddSceneEvent extends ImuViewEvent {
  ImuAddSceneEvent(this.scene);

  final Scene scene;
}

class ResetYawEvent extends ImuViewEvent {
  ResetYawEvent();
}

class UpdateKinematicsEvent extends ImuViewEvent {
  UpdateKinematicsEvent(this.kinematics);

  final Kinematics kinematics;
}
