import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/components/Scaffod.dart';
import 'package:inavconfiurator/home/reciever/bloc/reciever_bloc.dart';

class RecieverScreen extends StatefulWidget {
  const RecieverScreen({
    Key? key,
  }) : super(key: key);

  @override
  RecieverScreenState createState() {
    return RecieverScreenState();
  }
}

class RecieverScreenState extends State<RecieverScreen> {
  RecieverScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecieverBloc, RecieverState>(builder: (
      BuildContext context,
      RecieverState currentState,
    ) {
      return AppScaffold(title: "Reciever", body: _body());
    });
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }
}
