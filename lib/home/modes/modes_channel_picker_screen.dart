import 'package:flutter/material.dart';

class ModeChannelPickerScreen extends StatefulWidget {
  const ModeChannelPickerScreen({Key? key}) : super(key: key);

  @override
  ModeChannelPickerScreenState createState() {
    return ModeChannelPickerScreenState();
  }
}

class ModeChannelPickerScreenState extends State<ModeChannelPickerScreen> {
  ModeChannelPickerScreenState();
  late int selectedChannel;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, this.selectedChannel);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(title: Text("Channel Selector"), actions: [
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {},
            )
          ]),
          body: _body()),
    );
  }

  Widget _body() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          DropdownButton<String>(
            items: <String>['A', 'B', 'C', 'D'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          )
        ],
      ),
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