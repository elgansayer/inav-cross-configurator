import 'package:flutter/material.dart';

import 'package:inavconfigurator/models/vehicle_type.dart';

@immutable
class ModeInfo {
  ModeInfo(
      {required this.id,
      required this.name,
      required this.description,
      required this.channel,
      required this.vehicleType,
      required this.range});

  final int channel;
  final String description;
  final int id;
  final String name;
  final RangeValues range;
  final VehicleType vehicleType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModeInfo &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.channel == channel &&
        other.vehicleType == vehicleType &&
        other.range == range;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        channel.hashCode ^
        vehicleType.hashCode ^
        range.hashCode;
  }

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
