import 'package:flutter/material.dart';
import 'package:inavconfiurator/bigpacktest/index.dart';

class BigpacktestPage extends StatefulWidget {
  static const String routeName = '/bigpacktest';

  @override
  _BigpacktestPageState createState() => _BigpacktestPageState();
}

class _BigpacktestPageState extends State<BigpacktestPage> {
  final _bigpacktestBloc = BigpacktestBloc(UnBigpacktestState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INav'),
      ),
      body: BigpacktestScreen(bigpacktestBloc: _bigpacktestBloc),
    );
  }
}
