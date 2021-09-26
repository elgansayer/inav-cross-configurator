import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'home_screen.dart';

class TabPage {
  final IconData? iconData;
  final String? svgPath;
  final String tabName;
  final HomePages tabPage;

  TabPage(
    this.tabName,
    this.tabPage, {
    this.iconData,
    this.svgPath,
  });
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
