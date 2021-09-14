import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/home/welcome/bloc/welcome_bloc.dart';
import 'welcome_screen.dart';

class WelcomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeBloc(),
      child: WelcomeScreen(),
    );
  }
}
