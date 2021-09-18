import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inavconfiurator/app/bloc/app_bloc.dart';
import 'package:inavconfiurator/home/bloc/home_bloc.dart';
import 'package:inavconfiurator/home/home_page.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TabPage> tabPages = [
      new TabPage(Icons.check, "Overview", HomePages.overview),
      new TabPage(Icons.check, "Failsafe", HomePages.failsafe),
      new TabPage(Icons.directions_car, "IMU", HomePages.imu),
      new TabPage(Icons.computer, "Cli", HomePages.cli),
    ];

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
