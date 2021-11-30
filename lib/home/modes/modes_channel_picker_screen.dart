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

  late int selectedChannel = -1;

  final _formKey = GlobalKey<FormState>();

  Widget _body() {
    return Form(
      key: _formKey,
      child: ListView(
        children: List.generate(15, (index) => _slider(index)),
      ),
    );
  }

  Widget _slider(int index) {
    Color highlightColor = Theme.of(context).highlightColor;
    return Container(
      color: selectedChannel == index ? highlightColor : null,
      child: ListTile(
        title: Text("Channel $index"),
        subtitle: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: SliderComponentShape.noThumb,
          ),
          child: Slider(
            value: 500,
            min: 0,
            max: 1500,
            divisions: 1500,
            onChanged: null,
          ),
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          setState(() {
            selectedChannel = index;
          });
        },
      ),
    );
  }

  _getTitle() {
    return this.selectedChannel > 0
        ? Text("Selected channel ${this.selectedChannel}")
        : Text("Channel Selector");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, this.selectedChannel);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(title: _getTitle(), actions: [
            // IconButton(
            //   icon: Icon(Icons.help),
            //   onPressed: () {},
            // )
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