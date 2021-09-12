import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'setup_event.dart';
part 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc() : super(SetupInitial());

  @override
  Stream<SetupState> mapEventToState(
    SetupEvent event,
  ) async* {
    
  }
}
