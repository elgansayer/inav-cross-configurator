import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfigurator/models/mode_info.dart';

import '../../components/Scaffod.dart';
import 'bloc/modes_bloc.dart';
import 'modes.dart';

class ModePickerScreen extends StatefulWidget {
  final ModesBloc modesBloc;
  const ModePickerScreen({
    Key? key,
    required this.modesBloc,
  }) : super(key: key);

  @override
  ModePickerScreenState createState() {
    return ModePickerScreenState();
  }
}

class ModePickerScreenState extends State<ModePickerScreen> {
  ModePickerScreenState();
  List<ModeInfo> selectedModes = List<ModeInfo>.empty();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, this.selectedModes);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(title: Text("Add Modes"), actions: [
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {},
            )
          ]),
          body: _body()),
    );
  }

  _body() {
    List<ModeInfo> items = FlightModes.allModes;
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var mode = items[index];
        return ListTile(
          leading: Icon(Icons.car_rental),
          trailing: Icon(Icons.help),
          title: Text(mode.name),
          subtitle: Text(
            mode.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            this.selectedModes.add(mode);
          },
        );
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