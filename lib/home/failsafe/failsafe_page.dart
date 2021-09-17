import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/home/failsafe/bloc/failsafe_bloc.dart';
import 'failsafe_screen.dart';

class FailsafePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _FailsafePageState createState() => _FailsafePageState();
}

class _FailsafePageState extends State<FailsafePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FailsafeBloc(),
      child: FailsafeScreen(),
    );
  }
}
