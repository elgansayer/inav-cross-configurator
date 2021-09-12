import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/home/imu/bloc/imu_bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';

import 'imu_screen.dart';

class IMUPage extends StatefulWidget {
  static const String routeName = '/setup';

  @override
  _IMUPageState createState() => _IMUPageState();
}

class _IMUPageState extends State<IMUPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ImuViewBloc>(
          create: (context) => ImuViewBloc(
              serialDeviceRepository:
                  RepositoryProvider.of<SerialDeviceRepository>(context)),
        ),
        // BlocProvider<SetupBloc>(
        //   create: (context) => SetupBloc(),
        // ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('IMU'),
        ),
        body: IMUScreen(),
      ),
    );
  }
}
