import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'motors_event.dart';
part 'motors_state.dart';

class MotorsBloc extends Bloc<MotorsEvent, MotorsState> {
  MotorsBloc() : super(MotorsInitial());
}
