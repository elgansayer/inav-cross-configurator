import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/components/Scaffod.dart';

class PIDTuningScreen extends StatefulWidget {
  const PIDTuningScreen({
    Key? key,
  }) : super(key: key);

  @override
  PIDTuningScreenState createState() {
    return PIDTuningScreenState();
  }
}

class PIDTuningScreenState extends State<PIDTuningScreen> {
  PIDTuningScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PIDTuningBloc, PIDTuningState>(builder: (
      BuildContext context,
      PIDTuningState currentState,
    ) {
      return AppScaffold(title: "PIDTuning", body: _body());
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
