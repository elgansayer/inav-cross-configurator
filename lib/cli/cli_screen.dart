import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cli_bloc.dart';

class CliScreen extends StatefulWidget {
  const CliScreen({
    Key? key,
  }) : super(key: key);

  @override
  CliScreenState createState() {
    return CliScreenState();
  }
}

class CliScreenState extends State<CliScreen> {
  CliScreenState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CliBloc, CliState>(builder: (
      BuildContext context,
      CliState currentState,
    ) {
      return _buildBody();
      // if (currentState is UnCliState) {
      //   return Center(
      //     child: CircularProgressIndicator(),
      //   );
      // }
      // if (currentState is ErrorCliState) {
      //   return Center(
      //       child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(currentState.errorMessage),
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
      // if (currentState is InCliState) {
      //   return Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Text(currentState.hello),
      //       ],
      //     ),
      //   );
      // }
      // return Center(
      //   child: CircularProgressIndicator(),
      // );
    });
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: TextField(
                maxLines: null,
                minLines: null,
                expands: true,
                decoration: InputDecoration(
                    hintText: "Cli Command",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
              ),
              flex: 1),
          Container(
            padding: EdgeInsets.only(left: 0, bottom: 0, top: 0),
            // height: 60,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Cli Command",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.send,
                    // size: 18,
                  ),
                  // backgroundColor: Colors.blue,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTextField() {
    return Flexible(
      child: Container(
        child: TextField(
          style: TextStyle(fontSize: 15.0),
          decoration: InputDecoration.collapsed(
            hintText: 'Type a message',
          ),
        ),
      ),
    );
  }
}
