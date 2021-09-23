import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/Scaffod.dart';
import 'bloc/overview_bloc.dart';
import 'dashboard_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  InfoScreenState createState() {
    return InfoScreenState();
  }
}

class InfoScreenState extends State<InfoScreen> {
  InfoScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoBloc, InfoState>(builder: (
      BuildContext context,
      InfoState currentState,
    ) {
      return AppScaffold(
        title: "Overview",
        body: Center(
          child: DashboardScreen(),
        ),
      );
    });
  }
}
