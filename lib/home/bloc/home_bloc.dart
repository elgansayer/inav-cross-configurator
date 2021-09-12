import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:inavconfiurator/home/home_page.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.init());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    // switch (event) {
    //   case MyEvent.eventA:
    //     yield StateA();
    //     break;
    //   case MyEvent.eventB:
    //     yield StateB();
    //     break;
    // }
  }
}
