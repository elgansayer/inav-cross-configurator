import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'home_screen.dart';

class TabPage {
  final IconData iconData;
  final String tabName;
  final HomePages tabPage;

  TabPage(
    this.iconData,
    this.tabName,
    this.tabPage,
  );
}

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: HomeScreen(),
    );
  }
}
