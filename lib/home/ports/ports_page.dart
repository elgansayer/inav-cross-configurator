import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/ports_bloc.dart';
import 'ports_screen.dart';

class PortsPage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _PortsPageState createState() => _PortsPageState();
}

class _PortsPageState extends State<PortsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PortsBloc(),
      child: PortsScreen(),
    );
  }
}
