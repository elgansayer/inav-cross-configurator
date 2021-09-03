import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cli_bloc.dart';
import 'cli_screen.dart';

class CliPage extends StatefulWidget {
  static const String routeName = '/cli';

  @override
  _CliPageState createState() => _CliPageState();
}

class _CliPageState extends State<CliPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CliBloc(),
      child: CliScreen(),
    );
  }
}
