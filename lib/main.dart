import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/components/bloc/errorbanner_bloc.dart';
import 'package:inavconfiurator/serial/serialdevice_repository.dart';

import 'app/bloc/app_bloc.dart';
import 'components/bloc/errormessage_repository.dart';
import 'devices/devices_page.dart';
import 'home/home_page.dart';
// https://github.com/iNavFlight/inav/wiki/MSP-V2

void main() {
  runApp(
    MultiRepositoryProvider(
      // create: (_) => SerialDeviceRepository(),
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
      title: 'INav Configurator',
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
            default:
              return _homeView();
          }
        },
      ),
    );
  }

  _homeView() {
    return HomePage();
  }

  _devicesPageView() {
    return DevicesPage();
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     // showPorts();
//     openBoard();

//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
