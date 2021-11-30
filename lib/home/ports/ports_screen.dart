import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/scaffod.dart';
import 'bloc/ports_bloc.dart';

class PortsScreen extends StatefulWidget {
  const PortsScreen({
    Key? key,
  }) : super(key: key);

  @override
  PortsScreenState createState() {
    return PortsScreenState();
  }
}

class PortsScreenState extends State<PortsScreen> {
  PortsScreenState();

  _body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortsBloc, PortsState>(builder: (
      BuildContext context,
      PortsState currentState,
    ) {
      return AppScaffold(title: "Ports", body: _body());
    });
  }
}
