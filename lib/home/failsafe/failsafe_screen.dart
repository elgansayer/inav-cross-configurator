import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/Scaffod.dart';
import 'bloc/failsafe_bloc.dart';

class FailsafeScreen extends StatefulWidget {
  const FailsafeScreen({
    Key? key,
  }) : super(key: key);

  @override
  FailsafeScreenState createState() {
    return FailsafeScreenState();
  }
}

class FailsafeScreenState extends State<FailsafeScreen> {
  FailsafeScreenState();

  late TextEditingController _delayController = new TextEditingController();
  late TextEditingController _guardTimeController = new TextEditingController();
  late TextEditingController _throttleController = new TextEditingController();

  _body() {
    var _currencies = [
      "Land",
      "RTH",
    ];

    _delayController.text = "30";
    _throttleController.text = "20";
    _guardTimeController.text = "10";

    return Column(
      children: [
        new ListTile(
          leading: const Icon(Icons.wallet_giftcard),
          title: new TextFormField(
            controller: _guardTimeController,
            decoration: new InputDecoration(
              suffixStyle: TextStyle(fontSize: 20),
              counterText: '1000cm',
              counterStyle:
                  TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
              suffixText: "m",
              labelText: 'Guard time for activation after signal lost',
              hintText:
                  "Guard time for activation after signal lost [1 = 0.1 sec.]",
            ),
          ),
        ),
        ListTile(
            leading: const Icon(Icons.merge_type),
            subtitle: DropdownButtonFormField(
              items: _currencies.map((String category) {
                return new DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: <Widget>[
                        Text(category),
                      ],
                    ));
              }).toList(),
              value: "Land",
              onChanged: (String? value) {},
            )),
        new ListTile(
          leading: const Icon(Icons.speed),
          title: new TextField(
            controller: _throttleController,
            decoration: new InputDecoration(
              suffixStyle: TextStyle(fontSize: 20),
              counterText: '2000m',
              counterStyle:
                  TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
              suffixText: "m",
              labelText: 'Throttle value used while landing',
              hintText: "Throttle value used while landing",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.time_to_leave),
          title: new TextField(
            controller: _delayController,
            decoration: new InputDecoration(
              suffixStyle: TextStyle(fontSize: 20),
              counterText: '3000m',
              counterStyle:
                  TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
              suffixText: "m",
              labelText: 'Delay for turning off the Motors',
              hintText: "Delay for turning off the Motors",
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FailsafeBloc, FailsafeState>(builder: (
      BuildContext context,
      FailsafeState currentState,
    ) {
      return AppScaffold(title: "Failsafe", body: _body());
    });
  }
}
