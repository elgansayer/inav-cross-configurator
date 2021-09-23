import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../serial/serialport_model.dart';
import 'bloc/devices_bloc.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({
    Key? key,
  }) : super(key: key);

  @override
  DevicesScreenState createState() {
    return DevicesScreenState();
  }
}

class DevicesScreenState extends State<DevicesScreen> {
  DevicesScreenState();

  Widget _foundDevices(List<SerialPortInfo> serialPorts) {
    List<Widget> portCards =
        serialPorts.map((serialPort) => _portCard(serialPort)).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 8.0, // gap between lines
          children: portCards,
        ),
      ),
    );
  }

  Widget _portCard(SerialPortInfo serialPort) {
    double size = 100;

    return Container(
      height: size,
      width: size,
      child: InkWell(
          onTap: () {
            BlocProvider.of<DevicesPageBloc>(context)
                .add(DevicesPageEvent.connectToDeviceEvent(serialPort));
          },
          child: _portCardBody(serialPort)),
    );
  }

  _portCardBody(SerialPortInfo serialPort) {
    var icon = serialPort.isINav
        ? Image.asset('assets/images/inav_icon_128.png',
            fit: BoxFit.cover)
        : Icon(Icons.computer, size: 50.0);

    final CardTheme cardTheme = CardTheme.of(context);

    ShapeBorder? cardColour = serialPort.isINav
        ? const RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue)
            borderRadius: BorderRadius.all(Radius.circular(4.0)))
        : cardTheme.shape;

    return Card(
      shape: cardColour,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
          Text(
            serialPort.manufacturer,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(child: icon),
          Text(
            serialPort.name,
            overflow: TextOverflow.ellipsis,
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesPageBloc, DevicesPageState>(builder: (
      BuildContext context,
      DevicesPageState currentState,
    ) {
      if (currentState is FoundDevicesState) {
        return _foundDevices(currentState.serialPorts);
      }

      if (currentState is ConnectingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (currentState is ConnectedState) {
        return Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.done, size: 100),
                Text(currentState.serialPort.name),
                Text("Connected"),
              ],
            ),
          ),
        );
      }

      if (currentState is ErrorConnectionState) {
        return _foundDevices(currentState.serialPorts);
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No devices found"),
          ],
        ),
      );
    });
  }
}
