import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/info_bloc.dart';
import 'info_screen.dart';

class InfoPage extends StatefulWidget {
  static const String routeName = '/info';

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoBloc>(
      create: (context) => InfoBloc(),
      child: InfoScreen(),
    );
  }
}
