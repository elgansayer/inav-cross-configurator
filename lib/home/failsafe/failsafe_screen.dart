import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/components/Scaffod.dart';

class FailsafeScreen extends StatefulWidget {
  const FailsafeScreen({
    Key? key,
  }) : super(key: key);

  @override
  FailsafeScreenState createState() {
    return FailsafeScreenState();
  }
}

class FailsafeScreenState extends State<FailsafeScreen> {
  FailsafeScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FailsafeBloc, FailsafeState>(builder: (
      BuildContext context,
      FailsafeState currentState,
    ) {
      return AppScaffold(title: "Failsafe", body: _body());
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
