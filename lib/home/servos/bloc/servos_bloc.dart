import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'servos_event.dart';
part 'servos_state.dart';

class ServosBloc extends Bloc<ServosEvent, ServosState> {
  ServosBloc() : super(ServosInitial());

  @override
  Stream<ServosState> mapEventToState(
    ServosEvent event,
  ) async* {}
}
