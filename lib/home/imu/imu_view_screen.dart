import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:inavconfiurator/home/imu/bloc/imu_bloc.dart';

class ImuViewer extends StatefulWidget {
  const ImuViewer({
    Key? key,
  }) : super(key: key);

  @override
  ImuViewerState createState() {
    return ImuViewerState();
  }
}

class ImuViewerState extends State<ImuViewer> {
  ImuViewerState();

  _buildBody() {
    return Cube(
      interactive: false,
      onObjectCreated: (Object o) {
        BlocProvider.of<ImuViewBloc>(context).add(ImuAdd3DObjectEvent(o));
      },
      onSceneCreated: (Scene scene) {
        scene.world.add(Object(fileName: 'assets/models/iNav-Vtail.obj'));
        scene.camera.zoom = 20;
        scene.update();
        BlocProvider.of<ImuViewBloc>(context).add(ImuAddSceneEvent(scene));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
    // return BlocBuilder<ImuViewBloc, ImuViewState>(builder: (
    //   BuildContext context,
    //   ImuViewState currentState,
    // ) {

    //   // return Center(
    //   //   child: CircularProgressIndicator(),
    //   // );
    // });
  }
}
