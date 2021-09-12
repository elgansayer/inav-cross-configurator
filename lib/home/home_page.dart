import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/home/bloc/home_bloc.dart';

import 'home_screen.dart';

class TabPage {
  final IconData iconData;
  final String tabName;
  final Widget tabPage;

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
  // with SingleTickerProviderStateMixin {
  // late TabController _tabController;

  // final List<TabPage> tabPages = [
  //   new TabPage(Icons.check, "Overview", InfoPage()),
  //   new TabPage(Icons.directions_car, "IMU", SetupPage()),
  //   new TabPage(Icons.computer, "Cli", CliPage()),
  // ];

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(vsync: this, length: tabPages.length);
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: HomeScreen(),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('INav'),
    //     // bottom: TabBar(
    //     //   controller: _tabController,
    //     //   tabs: tabPages.map((tp) => tp.tab).toList(),
    //     // ),
    //     // title: const Text('INav'),
    //     actions: [],
    //   ),
    //   // body: TabBarView(
    //   //   controller: _tabController,
    //   //   children: tabPages.map((tp) => tp.tabPage).toList(),
    //   // ),
    //   // body: HomeScreen(homeBloc: _homeBloc),
    //   drawer: _buildDrawer(),
    // );
  }
}
