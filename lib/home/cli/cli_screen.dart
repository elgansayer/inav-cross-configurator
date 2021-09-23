import 'dart:io';

import 'package:code_text_field/code_text_field.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker_desktop/file_picker_desktop.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
// Import the language & theme
// import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inavconfigurator/home/cli/cli_syntax.dart';

import 'bloc/cli_bloc.dart';
import 'cli_help_screen.dart';
import 'commands.dart';

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

        _codeController = CodeController(
            text: state.message,
            language: cliSyntax,
            theme: monokaiSublimeTheme);

        if (state.excitedCli) {
          Navigator.pop(context);
        }
      },
      builder: (context, CliState state) {
        return _buildBar(state);
      },
    );
  }

  _buildBar(CliState state) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text("Cli"), actions: [_buildMenu()]),
        body: state.connected ? _buildBody() : _buildBodyLoading(),
      ),
      onWillPop: () async {
        BlocProvider.of<CliBloc>(context).add(ExitCliEvent());
        return false;
      },
    );
  }

  _buildMenu() {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.file_download),
            title: Text('Save to file'),
            onTap: () {
              _saveFile();
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('Copy to clipboard'),
            onTap: () {
              FlutterClipboard.copy(this._textConsoleController.text)
                  .then((value) {
                final snackBar = SnackBar(content: Text('Copied to clipboard'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.import_export),
            title: Text('Import'),
            onTap: () {
              this._openFile();
            },
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CliHelpScreen()),
              );
            },
          ),
        )
      ],
    );
  }

  Future<void> _openFile() async {
    try {
      final result = await pickFiles(
        allowMultiple: false,
      );

      if (result == null) {
        return;
      }

      String? path = result.files.single.path;
      if (path == null) {
        return;
      }

      File file = File(path);
      file.readAsLines().then((lines) => lines.forEach((line) => _send(line)));
    } catch (e) {
      final snackBar =
          SnackBar(content: Text('There was an error. File not opened'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _saveFile() async {
    try {
      final String? selectedFileName = await saveFile(
        defaultFileName: 'inav-dump.txt',
      );

      if (selectedFileName == null) {
        return;
      }

      File file = File(selectedFileName);

      // Write the file
      file.writeAsString(this._textConsoleController.text);

      final snackBar = SnackBar(content: Text('File saved'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar =
          SnackBar(content: Text('There was an error. File not saved'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _buildBodyLoading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
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
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(child: _textinput()),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: this._sendCmd,
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

  _textinput() {
    return TypeAheadField(
        hideOnLoading: true,
        hideOnEmpty: true,
        hideOnError: true,
        animationDuration: Duration(milliseconds: 250),
        autoFlipDirection: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: this._textInputController,
          textInputAction: TextInputAction.go,
          onEditingComplete: () {
            this._sendCmd();
          },
          decoration:
              InputDecoration(hintText: "", labelText: 'Enter a command'),
        ),
        suggestionsCallback: (pattern) {
          return CliCommands.findCommands(pattern);
        },
        itemBuilder: (context, CliCommand suggestion) {
          return ListTile(
            dense: true,
            title: Text(suggestion.cmd,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(suggestion.description),
          );
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            constraints: BoxConstraints(maxHeight: 144)),
        onSuggestionSelected: (CliCommand suggestion) {
          this._send(suggestion.cmd);
        });

    // return Autocomplete<CliCommand>(
    //   optionsBuilder: (TextEditingValue textEditingValue) {
    //     if (textEditingValue.text == '') {
    //       return const Iterable<CliCommand>.empty();
    //     }

    //     return CliCommands.commands.where((CliCommand option) {
    //       return option.cmd.contains(textEditingValue.text.toLowerCase());
    //     });
    //   },
    //   onSelected: (CliCommand selection) {
    //     print('You just selected ${selection.cmd}');
    //     // this._sendCmd();
    //   },
    //   // displayStringForOption: (CliCommand option) => option.cmd,
    //   fieldViewBuilder: (BuildContext context,
    //       TextEditingController fieldTextEditingController,
    //       FocusNode fieldFocusNode,
    //       VoidCallback onFieldSubmitted) {
    //     return TextField(
    //       textInputAction: TextInputAction.go,
    //       onSubmitted: (value) {
    //         // this._sendCmd();
    //         onFieldSubmitted();
    //       },
    //       focusNode: fieldFocusNode,
    //       autofocus: true,
    //       controller: fieldTextEditingController,
    //       decoration: InputDecoration(
    //         hintText: "Cli Command",
    //       ),
    //     );
    //   },
    //   optionsViewBuilder: (BuildContext context,
    //       AutocompleteOnSelected<CliCommand> onSelected,
    //       Iterable<CliCommand> options) {
    //     return Positioned(
    //       child: Align(
    //         alignment: Alignment.topLeft,
    //         child: Material(
    //           child: Container(
    //             width: 300,
    //             color: Colors.teal,
    //             child: ListView.builder(
    //               padding: EdgeInsets.all(8.0),
    //               itemCount: options.length,
    //               itemBuilder: (BuildContext context, int index) {
    //                 final CliCommand option = options.elementAt(index);

    //                 return GestureDetector(
    //                   onTap: () {
    //                     onSelected(option);
    //                   },
    //                   child: ListTile(
    //                     title: Text(option.cmd),
    //                     subtitle: Text(option.description),
    //                   ),
    //                 );
    //               },
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
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
