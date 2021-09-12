import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/setup_bloc.dart';
import 'imu/bloc/imu_bloc.dart';
import 'imu/imu_view_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({
    Key? key,
  }) : super(key: key);

  @override
  SetupScreenState createState() {
    return SetupScreenState();
  }
}

class SetupScreenState extends State<SetupScreen> {
  SetupScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupBloc, SetupState>(builder: (
      BuildContext context,
      SetupState currentState,
    ) {
      return Center(
        child: Stack(
          children: [_buildModelView(), _buildinfoGraph()],
        ),
      );
    });
  }

  _buildModelView() {
    return InkWell(
      child: ImuViewer(),
      onTap: () {
        BlocProvider.of<ImuViewBloc>(context).add(ResetYawEvent());
      },
    );
  }

  _buildinfoGraph() {
    return BlocBuilder<ImuViewBloc, ImuViewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Heading: ${state.kinematics.heading}"),
              Text("Pitch: ${state.kinematics.pitch}"),
              Text("Roll: ${state.kinematics.roll}"),
            ],
          )),
        );
      },
    );
  }
}
