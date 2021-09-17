import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reciever_screen.dart';

class RecieverPage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _RecieverPageState createState() => _RecieverPageState();
}

class _RecieverPageState extends State<RecieverPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecieverBloc(),
      child: RecieverScreen(),
    );
  }
}
