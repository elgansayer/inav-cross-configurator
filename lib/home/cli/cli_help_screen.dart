import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CliHelpScreen extends StatefulWidget {
  CliHelpScreen({Key? key}) : super(key: key);

  @override
  _CliHelpScreenState createState() => _CliHelpScreenState();
}

class _CliHelpScreenState extends State<CliHelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("CLI Reference")), body: _buildBody());
  }

  _buildBody() {
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
}
