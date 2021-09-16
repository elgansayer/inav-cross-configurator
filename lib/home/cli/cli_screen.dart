import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import the language & theme
// import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:inavconfiurator/home/cli/cli_syntax.dart';

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
  final TextEditingController _textInputController =
      new TextEditingController();

  final TextEditingController _textConsoleController =
      new TextEditingController();

  CodeController? _codeController;

  CliScreenState();

  @override
  void initState() {
    super.initState();
    // Instantiate the CodeController
    _codeController =
        CodeController(language: cliSyntax, theme: monokaiSublimeTheme);
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CliBloc, CliState>(
      listener: (context, state) {
        _textConsoleController.text = state.message;
        // _codeController?.text = state.message;

        _codeController = CodeController(
            text: state.message,
            language: cliSyntax,
            theme: monokaiSublimeTheme);
      },
      builder: (context, state) {
        return _buildTabBar();
      },
    );
  }

  _buildTabBar() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          // mainAxisSize: MainAxisSize.min,
          appBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.compare),
                // text: ("Cli"),
              ),
              Tab(
                icon: Icon(Icons.help),
                // text: ("Cli Reference"),
              ),
            ],
          ),
          body: _buildTabBody()),
    );
  }

  _buildTabBody() {
    return TabBarView(
      children: [_buildBody(), _buildHelp()],
    );
  }

  _buildHelp() {
    final theme = Theme.of(context);

    Set<List<String>> rows = {
      ['clear', 'clear the console'],
      ['1wire <esc>', 'passthrough 1wire to the specified esc'],
      ['adjrange', 'show/set adjustment ranges settings'],
      ['aux', 'show/set aux settings'],
      ['beeper', 'show/set beeper (buzzer)'],
      ['bind_rx', 'Initiate binding for RX_SPI or SRXL2 receivers'],
      ['mmix', 'design custom motor mixer'],
      ['smix', 'design custom servo mixer'],
      ['color', 'configure colors'],
      ['defaults', 'reset to defaults and reboot'],
      ['dump', 'print configurable settings'],
      ['diff', 'print only settings that have been modified'],
      ['exit', 'exit'],
      ['feature', 'list or -val or val'],
      ['get', 'get variable value'],
      ['gpspassthrough', 'passthrough gps to serial'],
      ['help', 'help'],
      ['led', 'configure leds'],
      ['map', 'mapping of rc channel order'],
      ['motor', 'get/set motor output value'],
      ['msc', 'Enter USB Mass storage mode'],
      ['play_sound', 'index, or none for next'],
      ['profile', 'index (0 to 2)'],
      ['rxrange', 'Define safe home locations'],
      ['save', 'save and reboot'],
      ['serial', 'Configure serial ports'],
      [
        'serialpassthrough <id> <baud> <mode>',
        'where id is the zero based port index, baud is a standard baud rate, and mode is rx, tx, or both (rxtx)'
      ],
      ['set', 'name=value or blank or * for list'],
      ['status', 'show system status'],
      ['temp_sensor', 'list or configure temperature sensor(s)'],
      ['wp', 'list or configure waypoints'],
      ['version', 'Displays version information']
    };
// Text(
//               "Backup via CLI",
//               style: theme.textTheme.subtitle1,
//             ),
//             Divider(),
//             Text(
//               "Dump via CLI",
//               style: theme.textTheme.subtitle2,
//             ),
//             Card(
//                 child: Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Text("profile 0\ndump"))),
//             Text(
//               "Dump profiles using cli",
//               style: theme.textTheme.subtitle2,
//             ),
//             Card(
//                 child: Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Text(
//                         "profile 1\ndump profile\nprofile 2\ndump profile\n"))),
//             Text(
//                 "Alternatively, use the `diff` command to dump only those settings that differ from their default values (those that have been changed)."),
//             Padding(
//               padding: const EdgeInsets.only(top: 50),
//               child: Text(
//                 "Restore via CLI",
//                 style: theme.textTheme.subtitle1,
//               ),
//             ),
//             Divider(),
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
              title: Text(
                  "A detailed online guide can be found at the home of INAV"),
              subtitle: Text("Visit Command Line Interface (CLI)"),
              trailing: Icon(Icons.open_in_browser),
              onTap: () {
                //https://github.com/iNavFlight/inav/blob/master/docs/Cli.md
              }),
          Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
            child: Text(
              "CLI Command Reference",
              style: theme.textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Command',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Description',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                ],
                rows: rows.map((e) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(e.first)),
                      DataCell(Text(e.last))
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                // child: CodeField(
                //     // readOnly: true,
                //     maxLines: null,
                //     minLines: null,
                //     expands: true,
                //     // textStyle: TextStyle(fontFamily: 'SourceCode'),
                //     controller: _codeController!)
                child: TextField(
                  controller: _textConsoleController,
                  readOnly: true,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  decoration: InputDecoration(
                      fillColor: Colors.black54,
                      filled: true,
                      border: InputBorder.none),
                ),
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
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      this._sendCmd();
                    },
                    // focusNode: ,
                    autofocus: true,
                    controller: _textInputController,
                    decoration: InputDecoration(
                      hintText: "Cli Command",
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: _sendCmd,
                  child: Icon(Icons.send, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary: Colors.blue, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendCmd() {
    final cliCmd = _textInputController.text;
    this._send(cliCmd);
    _textInputController.clear();
  }

  void _send(String cliCmd) {
    BlocProvider.of<CliBloc>(context).add(SendCliCmdEvent(cliCmd: cliCmd));
  }
}
