import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/components/bloc/errorbanner_bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';

import 'app/bloc/app_bloc.dart';
import 'components/bloc/errormessage_repository.dart';
import 'connecting/connecting_scren.dart';
import 'devices/devices_page.dart';
import 'home/home_page.dart';
// https://github.com/iNavFlight/inav/wiki/MSP-V2

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SerialDeviceRepository>(
            create: (_) => SerialDeviceRepository()),
        RepositoryProvider<ErrorMessageRepository>(
            create: (_) => ErrorMessageRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              serialDeviceRepository:
                  RepositoryProvider.of<SerialDeviceRepository>(context),
            ),
          ),
          BlocProvider(
              create: (context) => ErrorBannerBloc(
                    errorMessageRepository:
                        RepositoryProvider.of<ErrorMessageRepository>(context),
                  ))
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'INAV Configurator',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: BlocBuilder<AppBloc, AppState>(
        builder: (BuildContext context, AppState state) {
          switch (state.appPage) {
            case AppPage.devices:
              return _devicesPageView();
            case AppPage.home:
              return _homeView();
            case AppPage.connecting:
              return _connectingView();
            default:
              return _homeView();
          }
        },
      ),
    );
  }

  _connectingView() {
    return ConnectingScreen();
  }

  _homeView() {
    return HomePage();
  }

  _devicesPageView() {
    return DevicesPage();
  }
}
