import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/bigpacktest/index.dart';

class BigpacktestScreen extends StatefulWidget {
  const BigpacktestScreen({
    required BigpacktestBloc bigpacktestBloc,
    Key? key,
  })  : _bigpacktestBloc = bigpacktestBloc,
        super(key: key);

  final BigpacktestBloc _bigpacktestBloc;

  @override
  BigpacktestScreenState createState() {
    return BigpacktestScreenState();
  }
}

class BigpacktestScreenState extends State<BigpacktestScreen> {
  BigpacktestScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BigpacktestBloc, BigpacktestState>(
        bloc: widget._bigpacktestBloc,
        builder: (
          BuildContext context,
          BigpacktestState currentState,
        ) {
          if (currentState is UnBigpacktestState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorBigpacktestState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
              ],
            ));
          }
          if (currentState is InBigpacktestState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._bigpacktestBloc.add(LoadBigpacktestEvent());
  }
}
