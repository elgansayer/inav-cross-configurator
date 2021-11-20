import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../home_page.dart';

part 'home_event.dart';
part 'home_state.dart';

enum HomePages { overview, calibration, imu, modes, failsafe, cli }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.init()) {
    on<ChangeHomePageEvent>(
        (event, emit) => emit(HomeState(tabPage: event.tabPage)));
  }
}
