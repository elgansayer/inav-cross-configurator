import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {Key? key,
      required this.title,
      required this.body,
      this.actions,
      this.appBar})
      : super(key: key);

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.appBar ??
          AppBar(
            title: Text(title),
            actions: actions,
          ),
      body: body,
      drawer: SideDrawer(),
    );
  }
}
