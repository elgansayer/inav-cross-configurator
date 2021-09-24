import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfigurator/serial/serialdevice_repository.dart';

import 'bloc/overview_bloc.dart';
import 'overview_screen.dart';

class InfoPage extends StatefulWidget {
  static const String routeName = '/info';

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoBloc>(
      create: (context) => InfoBloc(
          serialDeviceRepository:
              RepositoryProvider.of<SerialDeviceRepository>(context)),
      child: InfoScreen(),
    );
  }
}
