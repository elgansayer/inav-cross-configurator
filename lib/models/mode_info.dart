import 'package:flutter/material.dart';
import 'package:inavconfigurator/models/vehicle_type.dart';

class ModeInfo {
  final int id;
  final String name;
  final String description;
  final int channel;
  final VehicleType vehicleType;
  final RangeValues range;

  ModeInfo(
      {required this.id,
      required this.name,
      required this.description,
      required this.channel,
      required this.vehicleType,
      required this.range});

  ModeInfo copyWith({
    int? id,
    String? name,
    String? description,
    int? channel,
    VehicleType? vehicleType,
    RangeValues? range,
  }) {
    return ModeInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      channel: channel ?? this.channel,
      vehicleType: vehicleType ?? this.vehicleType,
      range: range ?? this.range,
    );
  }
}
