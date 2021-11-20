import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
// Silly object naming
// ignore: implementation_imports
import 'package:flutter_cube/src/object.dart' as CubeObject;
import 'package:meta/meta.dart';

import '../../../msp/codes.dart';
import '../../../msp/codes/attitude.dart';
import '../../../msp/msp_message.dart';
import '../../../serial/serialdevice_repository.dart';

part 'imu_event.dart';
part 'imu_state.dart';

class ImuViewBloc extends Bloc<ImuViewEvent, ImuViewState> {
  ImuViewBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(ImuViewInitial()) {
    on<ImuAdd3DObjectEvent>((event, emit) => emit(
        ImuViewState(event.mdlObject, this.state.scene, Kinematics.zero())));

    on<ImuAddSceneEvent>((event, emit) => _imuAddSceneEvent(event, emit));
    on<ResetYawEvent>((event, emit) => _resetOrientation());
    on<UpdateKinematicsEvent>((event, emit) =>
        ImuViewState(this.state.object, this.state.scene, event.kinematics));
  }

  bool doneFirst = false;
  late MSPAttitude lastImu;
  late double yawFix = 0;

  final SerialDeviceRepository _serialDeviceRepository;
  late StreamSubscription<MSPMessageResponse> _streamListener;
  late Timer _timer;

  @override
  Future<void> close() {
    //cancel streams
    this._timer.cancel();
    this._streamListener.cancel();
    this._serialDeviceRepository.flush();
    return super.close();
  }

  _imuAddSceneEvent(event, emit) {
    emit(ImuViewState(this.state.object, event.scene, Kinematics.zero()));

    // Object fires twice, then scene
    this._setupScene();
    this._setupListeners();
  }

  _setupListeners() {
    this._streamListener = _serialDeviceRepository
        .responseStream(MSPCodes.mspAttitude)
        .listen((messageResponse) {
      MSPAttitude? rawImu = _serialDeviceRepository.transform(
          MSPCodes.mspAttitude, messageResponse);

      if (rawImu == null) {
        return;
      }

      _updateObjectOrientation(rawImu);
    });

    Duration duration = Duration(milliseconds: 75);
    this._timer = Timer.periodic(duration, this._updateImu);
  }

  Future<void> _updateImu(Timer timer) async {
    try {
      print("Writing imu ${timer.tick}");
      _serialDeviceRepository.writeFunc(MSPCodes.mspAttitude);
    } catch (e) {
      this.close();
    }
  }

  void _resetOrientation() {
    CubeObject.Object? mdlObject = this.state.object;
    Scene? scene = this.state.scene;

    if (mdlObject == null || scene == null) {
      return;
    }

    this.yawFix = this.lastImu.kinematics.z;
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

    // double roll = (rawImu.kinematics.x * -1.0);
    // double heading = ((rawImu.kinematics.z * -1.0) - this.yawFix);
    // double pitch = (rawImu.kinematics.y * -1.0);

    if (!this.doneFirst) {
      this.doneFirst = true;
      this.yawFix = rawImu.kinematics.z;
    }

    double kinematicsRoll = rawImu.kinematics.x;
    double kinematicsHeading = rawImu.kinematics.z;
    double kinematicsPitch = rawImu.kinematics.y;

    double roll = (kinematicsRoll * -1.0);
    double heading = ((kinematicsHeading - this.yawFix) * -1.0);
    double pitch = (kinematicsPitch * -1.0);

    mdlObject.rotation.setValues(pitch, heading, roll);
    mdlObject.updateTransform();

    scene.update();

    // Add event to update the display
    Kinematics kinematics =
        new Kinematics(kinematicsHeading, kinematicsRoll, kinematicsPitch);
    this.add(UpdateKinematicsEvent(kinematics));
  }

  void _setupScene() {
    Scene? scene = this.state.scene;

    if (scene == null) {
      return;
    }

    scene.world.rotation.setValues(0, 180, 0);
    scene.world.updateTransform();
    scene.update();
  }
}
