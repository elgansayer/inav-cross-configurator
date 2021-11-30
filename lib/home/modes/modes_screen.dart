import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfigurator/home/modes/mode_card.dart';
import 'package:inavconfigurator/models/mode_info.dart';

import '../../components/scaffod.dart';
import 'bloc/modes_bloc.dart';
import 'modes_channel_picker_screen.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Arm Mode is required"),
          ),
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: currentState.modes.length,
                itemBuilder: (BuildContext context, int index) {
                  ModeInfo mode = currentState.modes[index];
                  return _modeCard(mode);
                }),
          ),
        ],
      ),
    );
  }

  _modeCard(ModeInfo mode) {
    return ModeCard(
      modeInfo: mode,
      onChannelSelect: () async {
        int channel = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => ModeChannelPickerScreen()));

        if (channel > 0) {
          BlocProvider.of<ModesBloc>(context)
              .add(ChangeChannelEvent(mode: mode, channel: channel));
        }
      },
      onRemovePressed: () {
        BlocProvider.of<ModesBloc>(context).add(RemoveModeEvent(mode: mode));
      },
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

                ModesBloc modesBloc = BlocProvider.of<ModesBloc>(context);
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

                modesBloc.add(AddNewModesEvent(modes: selectedModes));
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