import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'app/bloc/app_bloc.dart';
import 'components/bloc/errorbanner_bloc.dart';
import 'components/bloc/errormessage_repository.dart';
import 'devices/devices_page.dart';
import 'home/home_page.dart';
import 'serial/serialdevice_repository.dart';
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
  _doNastyStuffsBeforeExit(BuildContext context) {
    var repo = RepositoryProvider.of<SerialDeviceRepository>(context);
    repo.disconnect();
    return true;
  }

  // _connectingView() {
  //   return ConnectingScreen();
  // }

  _homeView() {
    return HomePage();
  }

  _devicesPageView() {
    return DevicesPage();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _doNastyStuffsBeforeExit(context),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // localizationsDelegates: [
        //   S.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        // ],
        // supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
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
              // case AppPage.connecting:
              // return _connectingView();
              default:
                return _homeView();
            }
          },
        ),
      ),
    );
  }
}
