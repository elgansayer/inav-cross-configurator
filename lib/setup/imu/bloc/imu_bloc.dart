import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/codes/raw_imu.dart';
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
      yield new ImuViewState(event.mdlObject, this.state.scene);
    }
    if (event is ImuAddSceneEvent) {
      yield new ImuViewState(this.state.object, event.scene);
    }
  }

  _setupListeners() {
    _serialDeviceRepository
        .responseStreams(MSPCodes.mspRawImu)
        .listen((messageResponse) {
      //
      MSPRawImu? rawImu = _serialDeviceRepository.transform(
          MSPCodes.mspRawImu, messageResponse);
      if (rawImu == null) {
        return;
      }

      _updateObjectOrientation(rawImu);
    });

    this._timer = Timer.periodic(Duration(microseconds: 500), this._updateImu);
  }

  void _updateImu(Timer timer) {
    _serialDeviceRepository.write(MSPCodes.mspRawImu);
  }

  dispose() {
    this._timer.cancel();
  }

  void _updateObjectOrientation(MSPRawImu rawImu) {
    CubeObject.Object? mdlObject = this.state.object;
    Scene? scene = this.state.scene;

    if (mdlObject == null || scene == null) {
      return;
    }

    print(rawImu.gyroscope);

    mdlObject.rotation
        .setValues(rawImu.gyroscope.x, rawImu.gyroscope.y, rawImu.gyroscope.z);

    mdlObject.updateTransform();

    scene.update();
  }
}
