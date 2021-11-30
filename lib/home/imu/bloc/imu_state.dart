part of 'imu_bloc.dart';

@immutable
class Kinematics {
  Kinematics(this.heading, this.roll, this.pitch);

  factory Kinematics.zero() {
    return Kinematics(0, 0, 0);
  }

  final double heading;
  final double pitch;
  final double roll;
}

@immutable
class ImuViewState {
  ImuViewState(this.object, this.scene, this.kinematics);

  final Kinematics kinematics;
  final Object? object;
  final Scene? scene;
}

class ImuViewInitial extends ImuViewState {
  ImuViewInitial() : super(null, null, Kinematics.zero());
}
