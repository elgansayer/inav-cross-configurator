import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:inavconfigurator/models/mode_info.dart';
import 'bloc/modes_bloc.dart';
import 'modes.dart';

class ModePickerScreen extends StatefulWidget {
  const ModePickerScreen({
    Key? key,
    required this.modesBloc,
  }) : super(key: key);

  final ModesBloc modesBloc;

  @override
  ModePickerScreenState createState() {
    return ModePickerScreenState();
  }
}

class ModePickerScreenState extends State<ModePickerScreen> {
  ModePickerScreenState();

  List<ModeInfo> selectedModes = List<ModeInfo>.empty(growable: true);

  late List<GlobalKey<FlipCardState>> _cardKeys = List.empty(growable: true);

  @override
  void initState() {
    List<ModeInfo> items = FlightModes.allModes;
    _cardKeys.clear();
    _cardKeys = items.map((e) {
      return new GlobalKey<FlipCardState>();
    }).toList();

    super.initState();
  }

  _body() {
    List<ModeInfo> items = FlightModes.allModes;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        ModeInfo mode = items[index];
        bool modeSelected = this.selectedModes.contains(mode);
        ThemeData them = Theme.of(context);

        return Container(
          color: modeSelected ? them.highlightColor : Colors.transparent,
          child: ListTile(
            leading: FlipCard(
              key: _cardKeys.elementAt(index),
              flipOnTouch: false,
              front: Icon(Icons.car_rental),
              back: Icon(Icons.done),
            ),
            // modeSelected ? Container(child: Icon(Icons.done)) : Icon(Icons.car_rental),
            trailing: Icon(Icons.help),
            title: Text(mode.name),
            subtitle: Text(
              mode.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              setState(() {
                _cardKeys.elementAt(index).currentState?.toggleCard();
                if (modeSelected) {
                  this.selectedModes.remove(mode);
                } else {
                  this.selectedModes.add(mode);
                }
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, this.selectedModes);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
              title: selectedModes.length <= 0
                  ? Text("Add Modes")
                  : Text("${selectedModes.length} modes selected"),
              actions: [
                IconButton(
                  icon: Icon(Icons.help),
                  onPressed: () {},
                )
              ]),
          body: _body()),
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