import 'package:flutter/material.dart';
import 'package:inavconfiurator/home/index.dart';
import 'package:inavconfiurator/setup/bloc/setup_bloc.dart';
import 'package:inavconfiurator/setup/setup_screen.dart';

import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _homeBloc = HomeBloc();
  final _setupBloc = SetupBloc();
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
        title: const Text('INav'),
        actions: [
          TextButton(
              child: const Text('Disconnect'),
              onPressed: () {
                print('Pressed');
              })
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SetupScreen(setupBloc: _setupBloc),
          HomeScreen(homeBloc: _homeBloc),
          HomeScreen(homeBloc: _homeBloc),
        ],
      ),
      // body: HomeScreen(homeBloc: _homeBloc),
    );
  }
}
