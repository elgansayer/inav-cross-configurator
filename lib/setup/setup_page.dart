import 'package:flutter/material.dart';

import 'bloc/setup_bloc.dart';
import 'setup_screen.dart';

class SetupPage extends StatefulWidget {
  static const String routeName = '/setup';

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _setupBloc = SetupBloc();
//UnSetupState()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup'),
      ),
      body: SetupScreen(setupBloc: _setupBloc),
    );
  }
}
