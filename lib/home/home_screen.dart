import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';
import 'cli/cli_page.dart';
import 'failsafe/failsafe_page.dart';
import 'home_page.dart';
import 'imu/imu_page.dart';
import 'modes/modes_page.dart';
import 'overview/overview_page.dart';
import 'welcome/welcome_page.dart';

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
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, currentState) {
        final TabPage? tabPage = currentState.tabPage;
        if (tabPage?.tabPage == HomePages.cli) {
          _openCli();
        }
      },
      builder: (context, currentState) {
        final TabPage? tabPage = currentState.tabPage;
        return _getBody(tabPage);
      },
    );
  }

  _getBody(TabPage? tabPage) {
    Widget page = InfoPage();

    // Use a switch so we can dispose the page each time.
    // We could store the state though?
    // or we could keep the page in memory
    // and not dispose it.
    switch (tabPage?.tabPage) {
      case HomePages.failsafe:
        page = FailsafePage();
        break;
      case HomePages.modes:
        page = ModesPage();
        break;
      case HomePages.cli:
        // Return a welcome page over cli
        page = WelcomePage();
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

  // We open cli as a new window so we can
  // handle reconnect
  _openCli() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CliPage()),
    );
  }
}
