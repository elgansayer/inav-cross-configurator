import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {Key? key,
      required this.title,
      required this.body,
      this.actions,
      this.appBar})
      : super(key: key);

  final List<Widget>? actions;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final String title;

  _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(this.title),
        Container(
          width: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_armedIcon()],
            //_batteryIcon(),
          ),
        ),
      ],
    );
  }

  _batteryIcon() {
    return Column(
      children: [
        BatteryIndicator(
          style: BatteryIndicatorStyle.skeumorphism,
          colorful: true,
          showPercentNum: true,
          // mainColor: Colors.red,
          // size: 100,
          // ratio: 1,
          showPercentSlide: true,
        ),
        Text(
          "10v",
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  }

  _armedIcon() {
    return SvgPicture.asset('assets/images/icons/cf_icon_armed_grey.svg',
        color: Colors.grey, height: 24, fit: BoxFit.fitHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.appBar ??
          AppBar(
            title: _title(),
            actions: actions,
          ),
      body: body,
      drawer: SideDrawer(),
    );
  }
}
