part of 'imu_bloc.dart';

@immutable
class ImuViewState {
  final Object? object;
  final Scene? scene;

  ImuViewState(this.object, this.scene);
}

class ImuViewInitial extends ImuViewState {
  ImuViewInitial() : super(null, null);
}
