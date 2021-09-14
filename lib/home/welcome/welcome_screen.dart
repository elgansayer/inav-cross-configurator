import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inavconfiurator/home/welcome/bloc/welcome_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  WelcomeScreenState createState() {
    return WelcomeScreenState();
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
  WelcomeScreenState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WelcomeBloc, WelcomeState>(builder: (
      BuildContext context,
      WelcomeState currentState,
    ) {
      return _body();
    });
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _info(),
          _walkthroughts(),
        ],
      ),
    );
  }

  _info() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset('assets/images/cf_logo_white.svg', fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: SvgPicture.asset('assets/images/cf_logo_white.svg',
                        fit: BoxFit.cover)),
              ),
              Text(
                  "Welcome to INAV - Configurator, a utility designed to simplify updating, configuring and tuning of your flight controller.")
            ]),
      ),
    );
  }

  _walkthroughts() {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  "Walkthroughs",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            _walkthroughCard("Getting started with iNav"),
            _walkthroughCard("Multirotor guide",
                subtitle: "If you're going to use it in a multirotor."),
            _walkthroughCard("Fixed wing guide",
                subtitle: "If you're going to use it in a fixed wing model.."),
            _walkthroughCard("YouTube videos"),
            _walkthroughCard("INAv 3",
                subtitle: "From flash to flight YouTube playlist"),
            _walkthroughCard("INAv Wiki"),
          ]),
    ));
  }

  _walkthroughCard(String title, {String? subtitle}) {
    return Card(
        child: ListTile(
      leading: Icon(Icons.school),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: () {},
    ));
  }
}
