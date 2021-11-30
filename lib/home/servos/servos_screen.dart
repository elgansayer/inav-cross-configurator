import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/Scaffod.dart';
import 'bloc/servos_bloc.dart';

class ServosScreen extends StatefulWidget {
  const ServosScreen({
    Key? key,
  }) : super(key: key);

  @override
  ServosScreenState createState() {
    return ServosScreenState();
  }
}

class ServosScreenState extends State<ServosScreen> {
  ServosScreenState();

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
    return BlocBuilder<ServosBloc, ServosState>(builder: (
      BuildContext context,
      ServosState currentState,
    ) {
      return AppScaffold(title: "Servos", body: _body());
    });
  }
}
