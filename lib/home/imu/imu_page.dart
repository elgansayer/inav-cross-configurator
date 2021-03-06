import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/imu_bloc.dart';
import '../../serial/serialdevice_repository.dart';

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
      ],
      child: IMUScreen(),
    );
  }
}
