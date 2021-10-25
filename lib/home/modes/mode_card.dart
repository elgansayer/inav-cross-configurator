import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inavconfigurator/home/modes/mode_slider.dart';
import 'package:inavconfigurator/models/mode_info.dart';

class ModeCard extends StatelessWidget {
  const ModeCard(
      {Key? key,
      required this.onChannelSelect,
      required this.onRemovePressed,
      required this.modeInfo})
      : super(key: key);
  final ModeInfo modeInfo;

  final VoidCallback? onChannelSelect;
  final VoidCallback? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return _card(context);
  }

  _card(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
        child: ListTile(
          trailing: IconButton(
              onPressed: this.onRemovePressed,
              icon: Icon(Icons.delete_forever_rounded)),
          leading: Column(
            children: [
              Text(this.modeInfo.name),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: ElevatedButton(
                  child: Text(this.modeInfo.channel.toString()),
                  onPressed: this.onChannelSelect,
                ),
              )
            ],
          ),
          title: _slider(context),
          subtitle: Stack(
            children: [
              Container(
                height: 20,
                // child: Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     _vert(value: "900"),
                //     _vert(),
                //     _vert(),
                //     _vert(),
                //     _vert(value: "1500"),
                //     _vert(),
                //     _vert(),
                //     _vert(),
                //     _vert(value: "2100")
                //   ],
                // ),
              ),
              Positioned(
                left: 100,
                top: 0,
                child: Container(
                  width: 5,
                  height: 30,
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
      ),
    );
  }

  // _vert({String? value}) {
  //   return Container();
  //   Widget textVal = value != null ? Text(value) : Container();
  //   double height = value != null ? 8 : 5;
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Container(
  //         width: 1,
  //         height: height,
  //         color: Colors.grey,
  //       ),
  //       textVal
  //     ],
  //   );
  // }

  _slider(context) {
    return ModeSlider(range: this.modeInfo.range);
  }
}
