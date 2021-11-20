import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'servos_event.dart';
part 'servos_state.dart';

class ServosBloc extends Bloc<ServosEvent, ServosState> {
  ServosBloc() : super(ServosInitial());
}
