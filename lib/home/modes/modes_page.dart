import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfigurator/serial/serialdevice_repository.dart';

import 'bloc/modes_bloc.dart';
import 'modes_screen.dart';

class ModesPage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _ModesPageState createState() => _ModesPageState();
}

class _ModesPageState extends State<ModesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ModesBloc(
          serialDeviceRepository:
              RepositoryProvider.of<SerialDeviceRepository>(context)),
      child: ModesScreen(),
    );
  }
}
