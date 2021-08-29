import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:inavconfiurator/setup/imu/bloc/imu_bloc.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImuViewBloc, ImuViewState>(builder: (
      BuildContext context,
      ImuViewState currentState,
    ) {
      return _buildBody();

      // return Center(
      //   child: CircularProgressIndicator(),
      // );
    });
  }

  _buildBody() {
    return Cube(
      interactive: true,
      onObjectCreated: (o) {
        Timer.periodic(new Duration(milliseconds: 1), (timer) {
          // var r = o.rotation;
          // var d = o.rotation.z;
          // print(d);
          // double rad = radians(45);
          // o.rotation.setFrom(Vector3(rad, 0, rad));
          // o.transform.rotateX(rad);
          // o.transform.rotateY(rad);
          // o.transform.rotateZ(rad);
          // o.transform.setRotationX(rad);
          // o.transform.setRotationY(rad);
          // o.transform.setRotationZ(rad);
          o.updateTransform();
        });
      },
      onSceneCreated: (Scene scene) {
        scene.world.add(Object(fileName: 'assets/cube/cube.obj'));
        scene.camera.zoom = 8;
        scene.update();
        // scene.camera.position
      },
    );
  }
}
