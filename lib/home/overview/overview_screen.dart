import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/scaffod.dart';
import 'bloc/overview_bloc.dart';
import 'components/pre_arm_checks.dart';

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

  _buildBody(InfoState currentState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      PreArmChecks(),
                      // SizedBox(height: defaultPadding),
                      // RecentFiles(),
                      // if (Responsive.isMobile(context))
                      //   SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context)) StarageDetails(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoBloc, InfoState>(builder: (
      BuildContext context,
      InfoState currentState,
    ) {
      return AppScaffold(
        title: "Overview",
        body: SafeArea(
          child: _buildBody(currentState),
        ),
      );
    });
  }
}
