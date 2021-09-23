import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/Scaffod.dart';
import 'bloc/modes_bloc.dart';

class ModesScreen extends StatefulWidget {
  const ModesScreen({
    Key? key,
  }) : super(key: key);

  @override
  ModesScreenState createState() {
    return ModesScreenState();
  }
}

class ModesScreenState extends State<ModesScreen> {
  ModesScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModesBloc, ModesState>(builder: (
      BuildContext context,
      ModesState currentState,
    ) {
      return AppScaffold(title: "Modes", body: _body());
    });
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }
}
