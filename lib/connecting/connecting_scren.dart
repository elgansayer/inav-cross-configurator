import 'package:flutter/material.dart';

import '../components/error_banner.dart';

class ConnectingScreen extends StatefulWidget {
  const ConnectingScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConnectingScreenState createState() {
    return ConnectingScreenState();
  }
}

class ConnectingScreenState extends State<ConnectingScreen> {
  ConnectingScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ErrorWrapper(child: CircularProgressIndicator()));
  }
}
