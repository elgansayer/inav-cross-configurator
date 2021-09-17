import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/components/Scaffod.dart';
import 'package:inavconfiurator/home/motors/bloc/motors_bloc.dart';

class MotorsScreen extends StatefulWidget {
  const MotorsScreen({
    Key? key,
  }) : super(key: key);

  @override
  MotorsScreenState createState() {
    return MotorsScreenState();
  }
}

class MotorsScreenState extends State<MotorsScreen> {
  MotorsScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorsBloc, MotorsState>(builder: (
      BuildContext context,
      MotorsState currentState,
    ) {
      return AppScaffold(title: "Motors", body: _body());
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
