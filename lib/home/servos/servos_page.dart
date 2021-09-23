import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/servos_bloc.dart';
import 'servos_screen.dart';

class ServosPage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _ServosPageState createState() => _ServosPageState();
}

class _ServosPageState extends State<ServosPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServosBloc(),
      child: ServosScreen(),
    );
  }
}
