import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';

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

  @override
  void dispose() {
    BlocProvider.of<DevicesPageBloc>(context).dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

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
    var cardColour = serialPort.isINav ? Colors.blue.shade500 : null;
    double size = 150;

    return Container(
      height: size,
      width: size,
      child: InkWell(
        onTap: () {
          // Clear any banners
          // BlocProvider.of<ErrorBannerBloc>(context)
          //     .add(CloseErrorBannerEvent());

          BlocProvider.of<DevicesPageBloc>(context)
              .add(DevicesPageEvent.connectToDeviceEvent(serialPort));
        },
        child: Card(
          color: cardColour,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(serialPort.manufacturer),
              Expanded(child: Icon(Icons.computer, size: 50.0)),
              Text(
                serialPort.name,
              ),
            ]),
          ),
        ),
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
