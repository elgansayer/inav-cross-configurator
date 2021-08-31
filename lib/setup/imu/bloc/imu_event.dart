part of 'imu_bloc.dart';

@immutable
abstract class ImuViewEvent {}

class ImuAdd3DObjectEvent extends ImuViewEvent {
  final Object mdlObject;
  ImuAdd3DObjectEvent(this.mdlObject);
}

class ImuAddSceneEvent extends ImuViewEvent {
  final Scene scene;
  ImuAddSceneEvent(this.scene);
}

class ResetYawEvent extends ImuViewEvent {
  ResetYawEvent();
}

class UpdateKinematicsEvent extends ImuViewEvent {
  final Kinematics kinematics;
  UpdateKinematicsEvent(this.kinematics);
}
