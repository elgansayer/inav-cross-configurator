import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inavconfiurator/app/bloc/app_bloc.dart';
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

  final List<TabPage> tabPages = [
    new TabPage(Icons.check, "Overview", HomePages.overview),
    new TabPage(Icons.directions_car, "IMU", HomePages.imu),
    new TabPage(Icons.computer, "Cli", HomePages.cli),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (
      BuildContext context,
      HomeState currentState,
    ) {
      final TabPage? tabPage = currentState.tabPage;
      return Scaffold(
        appBar: AppBar(
          title: Text(tabPage?.tabName ?? 'INav'),
          // bottom: TabBar(
          //   controller: _tabController,
          //   tabs: tabPages.map((tp) => tp.tab).toList(),
          // ),
          // title: const Text('INav'),
          actions: [],
        ),
        // body: TabBarView(
        //   controller: _tabController,
        //   children: tabPages.map((tp) => tp.tabPage).toList(),
        // ),
        body: _getBody(tabPage),
        drawer: _buildDrawer(),
      );
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

  _buildDrawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(8),
            // decoration: BoxDecoration(
            //   color: Colors.blue,
            // ),
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Container(
                //       child: Align(
                //         alignment: Alignment.topLeft,
                //         child: Container(
                //             child: SvgPicture.asset(
                //                 'assets/images/light-wide-2.svg',
                //                 fit: BoxFit.fill)),
                //       ),
                //     ),
                //   ],
                // ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset('assets/images/light-wide-2.svg',
                      fit: BoxFit.fill),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.settings)))
              ],
            ),
            // child: SvgPicture.asset('assets/images/light-wide-2.svg',
            // fit: BoxFit.fitHeight),
          ),
          ...tabPages
              .map((tp) => ListTile(
                    leading: Icon(tp.iconData),
                    title: Text(tp.tabName),
                    onTap: () {
                      BlocProvider.of<HomeBloc>(context)
                          .add(ChangeHomePageEvent(tabPage: tp));

                      Navigator.pop(context);
                    },
                  ))
              .toList(),
          Divider(),
          Expanded(
            flex: 1,
            child: TextButton(
                child: const Text('Disconnect'),
                onPressed: () {
                  var appBloc = BlocProvider.of<AppBloc>(context);
                  appBloc.add(DisconnectEvent());
                }),
          )
        ],
      ),
    );
  }
}
