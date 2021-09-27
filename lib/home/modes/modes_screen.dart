import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/Scaffod.dart';
import 'bloc/modes_bloc.dart';

class ModesScreen extends StatefulWidget {
  const ModesScreen({
    Key? key,
  }) : super(key: key);

  @override
  ModesScreenState createState() {
    return ModesScreenState();
  }
}

class ModesScreenState extends State<ModesScreen> {
  ModesScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModesBloc, ModesState>(builder: (
      BuildContext context,
      ModesState currentState,
    ) {
      return AppScaffold(
          title: "Modes",
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            )
          ],
          body: _body());
    });
  }

  _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_modeCard()],
    );
  }

  _modeCard() {
    return Card(
      child: ListTile(
        trailing: IconButton(
            onPressed: null, icon: Icon(Icons.delete_forever_rounded)),
        leading: Column(
          children: [
            Text("ARM"),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: ElevatedButton(onPressed: null, child: Text("54")),
            )
          ],
        ),
        // title: Container(
        //   // color: Colors.red,
        //   height: 200,
        //   child: Stack(
        //     alignment: Alignment.topCenter,
        //     children: [
        //       Positioned(
        //         top: 10,
        //         // left: 0,
        //         // height: 250,
        //         // width: 0,
        //         // height: double.infinity,
        //         // width: double.infinity,
        //         // left: 0,
        //         // right: double.infinity,
        //         // top: 0,
        //         // bottom: double.infinity,
        //         // width: double.infinity,
        //         child: _slider(),
        //       ),
        //       Align(
        //         alignment: Alignment.topCenter,
        //         child: _slider(),
        //       ),
        //     ],
        //   ),
        // ),
        title: _slider(),
        subtitle: Stack(
          children: [
            Container(
              height: 35,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _vert(value: "100"),
                  _vert(),
                  _vert(),
                  _vert(),
                  _vert(value: "200"),
                  _vert(),
                  _vert(),
                  _vert(),
                  _vert(value: "300")
                ],
              ),
            ),
            Positioned(
              left: 100,
              top: 0,
              child: Container(
                width: 5,
                height: 25,
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue,
                        blurRadius: 1.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                          0.0,
                          -10.0,
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _vert({String? value}) {
    Widget textVal = value != null ? Text(value) : Container();
    double height = value != null ? 8 : 5;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 1,
          height: height,
          color: Colors.grey,
        ),
        textVal
      ],
    );
  }

  _rxSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.transparent,
        inactiveTrackColor: Colors.transparent,
        // trackShape: RectangularSliderTrackShape(),
        trackHeight: 10.0,
        // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        // thumbColor: Colors.redAccent,
        // overlayColor: Colors.red.withAlpha(32),
        // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
        // tickMarkShape: RoundSliderTickMarkShape(),
        // activeTickMarkColor: Colors.red[700],
        // inactiveTickMarkColor: Colors.red[100],
        // valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        // valueIndicatorColor: Colors.redAccent,
        // valueIndicatorTextStyle: TextStyle(
        // color: Colors.white,
        // ),
      ),
      child: Slider(
        value: 50,
        min: 0,
        max: 100,
        divisions: 10,
        // label: '$_value',
        onChanged: (value) {},
      ),
    );
  }

  _slider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        // activeTrackColor: Colors.red[700],
        // inactiveTrackColor: Colors.red[100],
        trackShape: RectangularSliderTrackShape(),
        trackHeight: 10.0,
        // thumbColor: Colors.redAccent,
        // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        // overlayColor: Colors.red.withAlpha(32),
        // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      ),
      child: RangeSlider(
          activeColor: Colors.blue[700],
          inactiveColor: Colors.red[300],
          // labels: RangeLabels('', ''),
          min: 1,
          max: 100,
          values: RangeValues(1, 100),
          onChanged: (values) {}),
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