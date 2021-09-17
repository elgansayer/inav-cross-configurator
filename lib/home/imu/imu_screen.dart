import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/components/Scaffod.dart';
import 'package:inavconfiurator/home/imu/bloc/imu_bloc.dart';
import 'package:inavconfiurator/home/imu/imu_view_screen.dart';

class IMUScreen extends StatefulWidget {
  const IMUScreen({
    Key? key,
  }) : super(key: key);

  @override
  IMUScreenState createState() {
    return IMUScreenState();
  }
}

class IMUScreenState extends State<IMUScreen> {
  IMUScreenState();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "IMU",
      body: Center(
        child: Stack(
          children: [_buildModelView(), _buildinfoGraph()],
        ),
      ),
    );
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
