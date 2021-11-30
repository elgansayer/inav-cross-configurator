import 'package:flutter/material.dart';

class ModeRange {
  ModeRange({
    required this.id,
    required this.auxChannelIndex,
    required this.range,
  });

  final int auxChannelIndex;
  final int id;
  final RangeValues range;
}
