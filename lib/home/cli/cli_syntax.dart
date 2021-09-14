// ignore_for_file: unused_import
//// ignore: implementation_imports
import 'package:highlight/src/mode.dart';
// ignore: implementation_imports
import 'package:highlight/src/common_modes.dart';

final cliSyntax = Mode(
    refs: {
      '~contains~0': Mode(begin: "`[\\s\\S]"),
    },
    case_insensitive: true,
    // aliases: ["help"],
    // // keywords: {
    // //   "keyword":
    // //       "Break Continue Critical Exit ExitApp Gosub Goto New OnExit Pause return SetBatchLines SetTimer Suspend Thread Throw Until ahk_id ahk_class ahk_pid ahk_exe ahk_group",
    // //   "literal": "true false NOT AND OR",
    // //   "built_in": "ComSpec Clipboard ClipboardAll ErrorLevel"
    // // },
    contains: [
      Mode(ref: '~contains~0'),
      Mode(
          className: "string",
          begin: "\"",
          end: "\"",
          illegal: "\\n",
          contains: [Mode(ref: '~contains~0')]),
      Mode(
          className: "string",
          begin: "'",
          end: "'",
          illegal: "\\n",
          contains: [Mode(ref: '~contains~0')]),

      Mode(className: "comment", begin: "#", end: "\$", relevance: 0),
      Mode(className: "number", begin: "\\b\\d+(\\.\\d+)?", relevance: 0),

      // Mode(className: "variable", begin: "%[a-zA-Z0-9#_\$@]+%"),
      // Mode(className: "built_in", begin: "^\\s*\\w+\\s*(,|%)"),
      // Mode(className: "title", variants: [
      //   Mode(begin: "^[^\\n\";]+::(?!=)"),
      //   Mode(begin: "^[^\\n\";]+:(?!=)", relevance: 0)
      // ]),
      // Mode(className: "meta", begin: "^\\s*#\\w+", end: "\$", relevance: 0),
      // Mode(className: "built_in", begin: "A_[a-zA-Z0-9]+"),
      // Mode(begin: ",\\s*,")
    ]);