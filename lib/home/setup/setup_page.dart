import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';

import 'bloc/setup_bloc.dart';
import 'imu/bloc/imu_bloc.dart';
import 'setup_screen.dart';

class SetupPage extends StatefulWidget {
  static const String routeName = '/setup';

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ImuViewBloc>(
          create: (context) => ImuViewBloc(
              serialDeviceRepository:
                  RepositoryProvider.of<SerialDeviceRepository>(context)),
        ),
        BlocProvider<SetupBloc>(
          create: (context) => SetupBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('IMU'),
        ),
        body: SetupScreen(),
      ),
    );
  }
}