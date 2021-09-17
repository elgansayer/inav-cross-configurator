import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/home/cli/cli_page.dart';
import 'package:inavconfiurator/home/welcome/welcome_page.dart';
import 'bloc/home_bloc.dart';
import 'home_page.dart';
import 'imu/imu_page.dart';
import 'info/info_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (
      BuildContext context,
      HomeState currentState,
    ) {
      final TabPage? tabPage = currentState.tabPage;
      return _getBody(tabPage);
    });
  }

  _getBody(TabPage? tabPage) {
    Widget page = InfoPage();

    // Use a switch so we can dispose the page each time.
    // We could store the state though?
    // or we could keep the page in memory
    // and not dispose it.
    switch (tabPage?.tabPage) {
      case HomePages.cli:
        page = CliPage();
        break;
      case HomePages.imu:
        page = IMUPage();
        break;
      case HomePages.overview:
        page = InfoPage();
        break;
      default:
        page = WelcomePage();
    }

    return page;
  }
}
