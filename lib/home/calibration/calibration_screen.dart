import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/Scaffod.dart';
import 'bloc/calibration_bloc.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({
    Key? key,
  }) : super(key: key);

  @override
  CalibrationScreenState createState() {
    return CalibrationScreenState();
  }
}

class AccCalibrationItem {
  AccCalibrationItem(this.svgPath, this.name, this.completed);

  final bool completed;
  final String name;
  final String svgPath;

  Color get color => this.completed ? Colors.blue : Colors.grey;
}

class CalibrationScreenState extends State<CalibrationScreen> {
  CalibrationScreenState();

  Widget _gridItem(AccCalibrationItem item) {
    Widget icon =
        (!item.completed) ? Container() : Icon(Icons.done, color: Colors.blue);

    final Size _size = MediaQuery.of(context).size;

    print(_size.width);
    double maxSize = max(75, (_size.width / 12) * 1.5);

    double itemHeight = maxSize;
    double boxHeight = itemHeight + 50;

    return Container(
      constraints: BoxConstraints(
          minHeight: 75,
          minWidth: 75,
          maxHeight: boxHeight,
          maxWidth: boxHeight),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              color: Colors.grey.withOpacity(.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                  icon,
                ],
              ),
            ),
            Container(
              child: SvgPicture.asset(item.svgPath,
                  color: item.color,
                  width: itemHeight,
                  height: itemHeight,
                  fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }

  _grid(CalibrationState currentState) {
    int itemIndex = 0;

    List<AccCalibrationItem> _items = currentState.accCalibrationStates
        .map((AccCalibrationState accCalibrationState) {
      itemIndex++;

      return AccCalibrationItem("assets/images/calibration/pos$itemIndex.svg",
          "Step $itemIndex", accCalibrationState.completed);
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text("Accelerometer Calibration",
              overflow: TextOverflow.ellipsis),
          trailing: ElevatedButton(
              onPressed: () {
                BlocProvider.of<CalibrationBloc>(context)
                    .add(StartAccCalibration());
              },
              child: Text(
                "Calibrate",
                overflow: TextOverflow.ellipsis,
              )),
        ),
        Wrap(
          children: _items.map((e) => _gridItem(e)).toList(),
        )
      ],
    );
  }

  _body(CalibrationState currentState) {
    return _grid(currentState);
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Processing Calibration'),
            content: Center(child: CircularProgressIndicator()),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('HelloWorld!'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalibrationBloc, CalibrationState>(
      listener: (context, state) {
        // if (state.accCalibration) {
        //   _showMaterialDialog();
        // }
      },
      builder: (context, state) {
        return BlocBuilder<CalibrationBloc, CalibrationState>(builder: (
          BuildContext context,
          CalibrationState currentState,
        ) {
          return AppScaffold(
              title: "Calibration",
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {},
                )
              ],
              body: _body(currentState));
        });
      },
    );
  }
}






















// subtitle: Container(
//           height: 100,
//           // color: Colors.red[50],
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   VerticalDivider(
//                     thickness: 1,
//                     // width: 10,
//                   ),
//                   Text("900")
//                 ],
//               ),
//               VerticalDivider(
//                 thickness: 1,
//                 // width: 10,
//               ),
//               // Column(
//               //   // crossAxisAlignment: CrossAxisAlignment.stretch,
//               //   children: [
//               //     VerticalDivider(
//               //       thickness: 10,
//               //       // width: 10,
//               //     ),
//               //     Text("900")
//               //   ],
//               // ),
//               // VerticalDivider(),
//               // Column(
//               //   // mainAxisSize: MainAxisSize.min,
//               //   // mainAxisAlignment: MainAxisAlignment.start,
//               //   children: [VerticalDivider(), Text("1500")],
//               // ),
//             ],
//           ),
//         ),