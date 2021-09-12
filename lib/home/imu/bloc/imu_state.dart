part of 'imu_bloc.dart';

@immutable
class Kinematics {
  final double heading;
  final double roll;
  final double pitch;

  factory Kinematics.zero() {
    return Kinematics(0, 0, 0);
  }

  Kinematics(this.heading, this.roll, this.pitch);
}

@immutable
class ImuViewState {
  final Object? object;
  final Scene? scene;
  final Kinematics kinematics;

  ImuViewState(this.object, this.scene, this.kinematics);
}

class ImuViewInitial extends ImuViewState {
  ImuViewInitial() : super(null, null, Kinematics.zero());
}
