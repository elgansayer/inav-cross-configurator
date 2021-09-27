import 'package:inavconfigurator/models/vehicle_type.dart';

class ModeInfo {
  final String name;
  final String description;
  final int channel;
  final VehicleType vehicleType;

  ModeInfo(
      {required this.name,
      required this.description,
      required this.channel,
      required this.vehicleType});
}
