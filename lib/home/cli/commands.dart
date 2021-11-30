class CliCommand {
  CliCommand(this.cmd, this.description);

  final String cmd;
  final String description;

  @override
  String toString() {
    return this.cmd;
  }
}

class CliCommands {
  static List<CliCommand> commands = [
    CliCommand('clear', 'clear the console'),
    CliCommand('1wire <esc>', 'passthrough 1wire to the specified esc'),
    CliCommand('adjrange', 'show/set adjustment ranges settings'),
    CliCommand('aux', 'show/set aux settings'),
    CliCommand('beeper', 'show/set beeper (buzzer)'),
    CliCommand('bind_rx', 'Initiate binding for RX_SPI or SRXL2 receivers'),
    CliCommand('mmix', 'design custom motor mixer'),
    CliCommand('smix', 'design custom servo mixer'),
    CliCommand('color', 'configure colors'),
    CliCommand('defaults', 'reset to defaults and reboot'),
    CliCommand('dump', 'print configurable settings'),
    CliCommand('diff', 'print only settings that have been modified'),
    CliCommand('exit', 'exit'),
    CliCommand('feature', 'list or -val or val'),
    CliCommand('get', 'get variable value'),
    CliCommand('gpspassthrough', 'passthrough gps to serial'),
    CliCommand('help', 'help'),
    CliCommand('led', 'configure leds'),
    CliCommand('map', 'mapping of rc channel order'),
    CliCommand('motor', 'get/set motor output value'),
    CliCommand('msc', 'Enter USB Mass storage mode'),
    CliCommand('play_sound', 'index, or none for next'),
    CliCommand('profile', 'index (0 to 2)'),
    CliCommand('rxrange', 'Define safe home locations'),
    CliCommand('save', 'save and reboot'),
    CliCommand('serial', 'Configure serial ports'),
    CliCommand('serialpassthrough <id> <baud> <mode>',
        'where id is the zero based port index, baud is a standard baud rate, and mode is rx, tx, or both (rxtx)'),
    CliCommand('set', 'name=value or blank or * for list'),
    CliCommand('status', 'show system status'),
    CliCommand('temp_sensor', 'list or configure temperature sensor(s)'),
    CliCommand('wp', 'list or configure waypoints'),
    CliCommand('version', 'Displays version information')
  ];

  static List<CliCommand> findCommands(String query) {
    List<CliCommand> matches = <CliCommand>[];
    matches.addAll(commands);

    matches
        .retainWhere((s) => s.cmd.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
