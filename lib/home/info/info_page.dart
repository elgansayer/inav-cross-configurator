import 'package:flutter/material.dart';

import 'info_screen.dart';

class InfoPage extends StatefulWidget {
  static const String routeName = '/info';

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
      ),
      body: InfoScreen(),
    );
  }
}
