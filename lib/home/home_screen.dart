import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required HomeBloc homeBloc,
    Key? key,
  })  : _homeBloc = homeBloc,
        super(key: key);

  final HomeBloc _homeBloc;

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: widget._homeBloc,
        builder: (
          BuildContext context,
          HomeState currentState,
        ) {
          // if (currentState is UnHomeState) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // if (currentState is ErrorHomeState) {
          //   return Center(
          //       child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Text(currentState.errorMessage),
          //       Padding(
          //         padding: const EdgeInsets.only(top: 32.0),
          //         child: RaisedButton(
          //           color: Colors.blue,
          //           child: Text('reload'),
          //           onPressed: _load,
          //         ),
          //       ),
          //     ],
          //   ));
          // }
          // if (currentState is InHomeState) {
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Text(currentState.hello),
          //         const Text('Flutter files: done'),
          //         Padding(
          //           padding: const EdgeInsets.only(top: 32.0),
          //           child: RaisedButton(
          //             color: Colors.red,
          //             child: Text('throw error'),
          //             onPressed: () => _load(true),
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }
          return _buildTabs();
        });
  }

  _buildTabs() {
    return Icon(Icons.directions_car);
  }
}
