import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/home/motors/bloc/motors_bloc.dart';
import 'motors_screen.dart';

class MotorsPage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _MotorsPageState createState() => _MotorsPageState();
}

class _MotorsPageState extends State<MotorsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MotorsBloc(),
      child: MotorsScreen(),
    );
  }
}
