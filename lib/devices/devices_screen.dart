import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inavconfiurator/serial/serialport_model.dart';

import 'bloc/devices_bloc.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConnectionScreenState createState() {
    return ConnectionScreenState();
  }
}

class ConnectionScreenState extends State<ConnectionScreen> {
  ConnectionScreenState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _foundDevices(FoundDevicesState currentState) {
    List<SerialPortInfo> serialPorts = currentState.serialPorts;
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
        return _foundDevices(currentState);
        // return Center(
        //   child: CircularProgressIndicator(),
        // );
      }

      if (currentState is ConnectingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (currentState is ConnectedState) {
        // // Redirect now connected
        // BlocProvider.of<AppBloc>(context).add(AppEvent.changePage(AppPage.home));

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

      // if (currentState is ErrorConnectionState) {
      //   return Center(
      //       child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(currentState.errorMessage ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 32.0),
      //         child: RaisedButton(
      //           color: Colors.blue,
      //           child: Text('reload'),
      //           onPressed: _load,
      //         ),
      //       ),
      //     ],
      //   ));
      // }

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
