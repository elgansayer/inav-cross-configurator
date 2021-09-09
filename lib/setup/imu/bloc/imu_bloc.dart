import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/codes/attitude.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';
import 'package:meta/meta.dart';
// Silly object naming
// ignore: implementation_imports
import 'package:flutter_cube/src/object.dart' as CubeObject;

part 'imu_event.dart';
part 'imu_state.dart';

class ImuViewBloc extends Bloc<ImuViewEvent, ImuViewState> {
  final SerialDeviceRepository _serialDeviceRepository;

  late Timer _timer;

  // TEMP. TODO: Move these to state
  late MSPAttitude lastImu;
  late double yawFix = 0;
  late StreamSubscription<MSPMessageResponse> _streamListener;

  ImuViewBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(ImuViewInitial()) {
    this._setupListeners();
  }

  @override
  Stream<ImuViewState> mapEventToState(
    ImuViewEvent event,
  ) async* {
    if (event is ImuAdd3DObjectEvent) {
      yield new ImuViewState(
          event.mdlObject, this.state.scene, Kinematics.zero());
    }
    if (event is ImuAddSceneEvent) {
      yield new ImuViewState(this.state.object, event.scene, Kinematics.zero());
    }

    if (event is ResetYawEvent) {
      _resetOrientation();
    }

    if (event is UpdateKinematicsEvent) {
      yield new ImuViewState(
          this.state.object, this.state.scene, event.kinematics);
    }
  }

  _setupListeners() {
    this._streamListener = _serialDeviceRepository
        .responseStreams(MSPCodes.mspAttitude)
        .listen((messageResponse) {
      MSPAttitude? rawImu = _serialDeviceRepository.transform(
          MSPCodes.mspAttitude, messageResponse);
      if (rawImu == null) {
        return;
      }

      _updateObjectOrientation(rawImu);
    });

    this._timer = Timer.periodic(Duration(microseconds: 500), this._updateImu);
  }

  Future<void> _updateImu(Timer timer) async {
    try {
      await _serialDeviceRepository.write(MSPCodes.mspAttitude);
    } catch (e) {
      this.close();
    }
  }

  @override
  Future<void> close() {
    //cancel streams
    this._timer.cancel();
    this._streamListener.cancel();
    return super.close();
  }

  void _resetOrientation() {
    CubeObject.Object? mdlObject = this.state.object;
    Scene? scene = this.state.scene;

    if (mdlObject == null || scene == null) {
      return;
    }

    this.yawFix = this.lastImu.kinematics.z * -1.0;
    mdlObject.rotation.setZero();

    mdlObject.updateTransform();
    scene.update();
  }

  void _updateObjectOrientation(MSPAttitude rawImu) {
    CubeObject.Object? mdlObject = this.state.object;
    Scene? scene = this.state.scene;

    if (mdlObject == null || scene == null) {
      return;
    }

    this.lastImu = rawImu;

    double roll = rawImu.kinematics.x;
    double heading = ((rawImu.kinematics.z * -1.0) - this.yawFix);
    double pitch = rawImu.kinematics.y;

    // interactive_block > a.reset
    // self.yaw_fix = SENSOR_DATA.kinematics[2] * - 1.0
    mdlObject.rotation.setZero();
    mdlObject.rotation.setValues(pitch, heading, roll);

    // look in this.render3D = function () {
    // compute the changes
    // model.rotation.x = (SENSOR_DATA.kinematics[1] * -1.0) * 0.017453292519943295;
    // modelWrapper.rotation.y = ((SENSOR_DATA.kinematics[2] * -1.0) - self.yaw_fix) * 0.017453292519943295;
    // model.rotation.z = (SENSOR_DATA.kinematics[0] * -1.0) * 0.017453292519943295;

    mdlObject.updateTransform();
    scene.update();

    // Add event to update the display
    var kinematics = new Kinematics(heading, roll * -1.0, pitch * -1.0);
    this.add(UpdateKinematicsEvent(kinematics));
  }
}
