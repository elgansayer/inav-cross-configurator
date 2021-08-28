import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/setup_bloc.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({
    required SetupBloc setupBloc,
    Key? key,
  })  : _setupBloc = setupBloc,
        super(key: key);

  final SetupBloc _setupBloc;

  @override
  SetupScreenState createState() {
    return SetupScreenState();
  }
}

class SetupScreenState extends State<SetupScreen> {
  SetupScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupBloc, SetupState>(
        bloc: widget._setupBloc,
        builder: (
          BuildContext context,
          SetupState currentState,
        ) {
          // if (currentState is UnSetupState) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // if (currentState is ErrorSetupState) {
          //   return Center(
          //       child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Text(currentState.errorMessage ),
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
          //  if (currentState is InSetupState) {
          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Text(currentState.hello),
          //       ],
          //     ),
          //   );
          // }
          return Center(
              child: CircularProgressIndicator(),
          );
          
        });
  }

  void _load() {
    // widget._setupBloc.add(LoadSetupEvent());
  }
}
