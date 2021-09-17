import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/home/pid/bloc/pid_tuning_bloc.dart';
import 'pid_tuning_screen.dart';

class PIDTuningPage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _PIDTuningPageState createState() => _PIDTuningPageState();
}

class _PIDTuningPageState extends State<PIDTuningPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PIDTuningBloc(),
      child: PIDTuningScreen(),
    );
  }
}
