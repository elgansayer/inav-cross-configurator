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

  _gridItem(AccCalibrationItem item) {
    Widget icon =
        (!item.completed) ? Container() : Icon(Icons.done, color: Colors.blue);

    return Card(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  item.svgPath,
                  color: item.color,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
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
                )
              ],
            ),
          ),
        ],
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

    final Size _size = MediaQuery.of(context).size;
    var crossAxisCount = 3;
    double childAspectRatio = 1;

    if (_size.width < 500) {
      crossAxisCount = 2;
      // childAspectRatio = 1;
    }

    if (_size.width < 400) {
      crossAxisCount = 2;
      childAspectRatio = 0.75;
    }

    if (_size.width < 200) {
      crossAxisCount = 2;
      childAspectRatio = 0.6;
    }

    if (_size.width < 150) {
      crossAxisCount = 1;
      childAspectRatio = 0.7;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: Text("Accelerometer Calibration",
              overflow: TextOverflow.ellipsis),
          trailing: ElevatedButton(
              onPressed: () {
                _showMaterialDialog();
                BlocProvider.of<CalibrationBloc>(context)
                    .add(StartAccCalibration());
              },
              child: Text(
                "Calibrate",
                overflow: TextOverflow.ellipsis,
              )),
        ),
        Flexible(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return _gridItem(_items[index]);
            },
          ),
        ),
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