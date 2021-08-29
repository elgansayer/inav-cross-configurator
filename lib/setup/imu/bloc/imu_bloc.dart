import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'imu_event.dart';
part 'imu_state.dart';

class ImuViewBloc extends Bloc<ImuViewEvent, ImuViewState> {
  ImuViewBloc() : super(ImuViewInitial());

  @override
  Stream<ImuViewState> mapEventToState(
    ImuViewEvent event,
  ) async* {}
}
