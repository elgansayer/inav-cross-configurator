import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/app/bloc/app_bloc.dart';
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
        title: Text('INav'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.directions_car), child: Text("Overview")),
            Tab(
                icon: Icon(Icons.align_vertical_bottom),
                child: Text("Calibration")),
            Tab(icon: Icon(Icons.computer), child: Text("Cli")),
          ],
        ),
        // title: const Text('INav'),
        actions: [
          TextButton(
              child: const Text('Disconnect'),
              onPressed: () {
                var appBloc = BlocProvider.of<AppBloc>(context);
                appBloc.add(DisconnectEvent());
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
