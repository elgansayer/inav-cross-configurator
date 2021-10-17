import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfigurator/serial/serialdevice_repository.dart';

import 'bloc/calibration_bloc.dart';
import 'calibration_screen.dart';

class CalibrationPage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _CalibrationPageState createState() => _CalibrationPageState();
}

class _CalibrationPageState extends State<CalibrationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalibrationBloc(
          serialDeviceRepository:
              RepositoryProvider.of<SerialDeviceRepository>(context)),
      child: CalibrationScreen(),
    );
  }
}
