import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import the language & theme
// import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:inavconfiurator/cli/cli_syntax.dart';

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
        return _buildBody();
      },
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
                  child: CodeField(
                      // readOnly: true,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      // textStyle: TextStyle(fontFamily: 'SourceCode'),
                      controller: _codeController!)
                  // child: TextField(
                  //   controller: _textConsoleController,
                  //   readOnly: true,
                  //   maxLines: null,
                  //   minLines: null,
                  //   expands: true,
                  //   decoration: InputDecoration(
                  //       fillColor: Colors.black54,
                  //       filled: true,
                  //       border: InputBorder.none),
                  // ),
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
