import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ports_event.dart';
part 'ports_state.dart';

class PortsBloc extends Bloc<PortsEvent, PortsState> {
  PortsBloc() : super(PortsInitial());

  @override
  Stream<PortsState> mapEventToState(
    PortsEvent event,
  ) async* {}
}
