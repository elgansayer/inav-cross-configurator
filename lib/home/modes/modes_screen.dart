import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfigurator/models/mode_info.dart';

import '../../components/Scaffod.dart';
import 'bloc/modes_bloc.dart';
import 'modes_picker_screen.dart';

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

  _body(ModesState currentState) {
    // if (currentState is ModesAvailableState) {
    //   return ListView.builder(
    //       itemCount: currentState.modes.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         ModeInfo mode = currentState.modes[index];
    //         return _modeCard(mode);
    //       });
    // }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [],
    );
  }

  _modeCard(ModeInfo mode) {
    return Card(
      child: ListTile(
        trailing: IconButton(
            onPressed: null, icon: Icon(Icons.delete_forever_rounded)),
        leading: Column(
          children: [
            Text(mode.name),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: ElevatedButton(
                  onPressed: null, child: Text(mode.channel.toString())),
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
        title: _slider(mode),
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

  // _rxSlider() {
  //   return SliderTheme(
  //     data: SliderTheme.of(context).copyWith(
  //       activeTrackColor: Colors.transparent,
  //       inactiveTrackColor: Colors.transparent,
  //       // trackShape: RectangularSliderTrackShape(),
  //       trackHeight: 10.0,
  //       // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
  //       // thumbColor: Colors.redAccent,
  //       // overlayColor: Colors.red.withAlpha(32),
  //       // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
  //       // tickMarkShape: RoundSliderTickMarkShape(),
  //       // activeTickMarkColor: Colors.red[700],
  //       // inactiveTickMarkColor: Colors.red[100],
  //       // valueIndicatorShape: PaddleSliderValueIndicatorShape(),
  //       // valueIndicatorColor: Colors.redAccent,
  //       // valueIndicatorTextStyle: TextStyle(
  //       // color: Colors.white,
  //       // ),
  //     ),
  //     child: Slider(
  //       value: 50,
  //       min: 0,
  //       max: 100,
  //       divisions: 10,
  //       // label: '$_value',
  //       onChanged: (value) {},
  //     ),
  //   );
  // }

  _slider(ModeInfo mode) {
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
          // 900, 1000, 1200, 1400, 1500, 1600, 1800, 2000, 2100
          divisions: 100,
          min: 900,
          max: 2100,
          values: mode.range,
          onChanged: (values) {}),
    );
  }

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
              onPressed: () async {
                // var currentModes = currentState.modes;

                var modesBloc = BlocProvider.of<ModesBloc>(context);
                List<ModeInfo> selectedModes = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ModePickerScreen(
                              // modes: currentModes,
                              modesBloc: modesBloc,
                            )));
                if (selectedModes.length <= 0) {
                  return;
                }

                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text('${selectedModes.length} modes added')));
              },
            )
          ],
          body: _body(currentState));
    });
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