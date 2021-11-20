import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'reciever_event.dart';
part 'reciever_state.dart';

class RecieverBloc extends Bloc<RecieverEvent, RecieverState> {
  RecieverBloc() : super(RecieverInitial());
}
