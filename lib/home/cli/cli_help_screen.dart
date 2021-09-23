import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'commands.dart';

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
                _launchGitHelp();
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
                rows: CliCommands.commands.map((e) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(e.cmd)),
                      DataCell(Text(e.description))
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

  void _launchGitHelp() async {
    String url = "https://github.com/iNavFlight/inav/blob/master/docs/Cli.md";
    await canLaunch(url);
  }
}
