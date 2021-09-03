import 'package:flutter/material.dart';
import 'package:inavconfiurator/cli/cli_page.dart';
import 'package:inavconfiurator/home/index.dart';
import 'package:inavconfiurator/setup/setup_page.dart';

import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _homeBloc = HomeBloc();
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
            Tab(icon: Icon(Icons.directions_car), child: Text("Setup")),
            Tab(icon: Icon(Icons.align_vertical_bottom), child: Text("To do")),
            Tab(icon: Icon(Icons.computer), child: Text("Cli")),
          ],
        ),
        // title: const Text('INav'),
        title:
            Image.asset('assets/images/cf_logo_white.svg', fit: BoxFit.cover),
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
          SetupPage(),
          HomeScreen(homeBloc: _homeBloc),
          CliPage(),
        ],
      ),
      // body: HomeScreen(homeBloc: _homeBloc),
    );
  }
}
