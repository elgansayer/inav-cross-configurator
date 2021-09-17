import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'modes_event.dart';
part 'modes_state.dart';

class ModesBloc extends Bloc<ModesEvent, ModesState> {
  ModesBloc() : super(ModesInitial());

  @override
  Stream<ModesState> mapEventToState(
    ModesEvent event,
  ) async* {}
}
