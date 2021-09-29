import 'package:flutter/material.dart';
import 'package:inavconfigurator/models/mode_info.dart';
import 'package:inavconfigurator/models/vehicle_type.dart';

class FlightModeIds {
  static int arm = 0;
  static int angle = 1;
  static int horizon = 2;
  static int navAlthold = 3;
  static int headingHold = 5;
  static int headfree = 6;
  static int headadj = 7;
  static int camstab = 8;
  static int navRth = 10;
  static int navPoshold = 11;
  static int manual = 12;
  static int beeper = 13;
  static int ledlow = 15;
  static int lights = 16;
  static int osdSw = 19;
  static int telemetry = 20;
  static int autoTune = 21;
  static int blackbox = 26;
  static int failsafe = 27;
  static int navWp = 28;
  static int airMode = 29;
  static int homeReset = 30;
  static int gcsNav = 31;
  static int fpvAngleMix = 32;
  static int surface = 33;
  static int flaperon = 34;
  static int turnAssist = 35;
  static int navLaunch = 36;
  static int servoAutotrim = 37;
  static int killswitch = 38;
  static int cameraControl1 = 39;
  static int cameraControl2 = 40;
  static int cameraControl3 = 41;
  static int osdAlt1 = 42;
  static int osdAlt2 = 43;
  static int osdAlt3 = 44;
  static int navCruise = 45;
  static int mcBraking = 46;
  static int user1 = 47;
  static int user2 = 48;
  static int loiterChange = 49;
}

class FlightModes {
  static List<ModeInfo> modes = [
    ModeInfo(
        id: FlightModeIds.arm,
        name: "Arm",
        vehicleType: VehicleType.all,
        description: "Aircraft is armed",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.angle,
        name: "ANGLE",
        vehicleType: VehicleType.all,
        description:
            "In this auto-leveled mode the roll and pitch channels control the angle between the relevant axis and the vertical, achieving leveled flight just by leaving the sticks centered. Maximum banking angle is limited by max_angle_inclination_rll and max_angle_inclination_pit",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.navAlthold,
        name: "ALTHOLD",
        vehicleType: VehicleType.all,
        description:
            "The altitude of the aircraft a the moment you activate this mode is fixed.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.autoTune,
        name: "AUTOTUNE",
        vehicleType: VehicleType.wing,
        description:
            "AUTOTUNE will attempt to tune roll and pitch P, I and FF gains on a fixed-wing airplane.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.beeper,
        name: "BEEPER",
        vehicleType: VehicleType.all,
        description:
            "Make the beeper connected to the FC beep (lost model finder).",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.blackbox,
        name: "BLACKBOX",
        vehicleType: VehicleType.all,
        description:
            "If you're recording to an onboard flash chip, you probably want to disable Blackbox recording when not required in order to save storage space. To do this, you can add a Blackbox flight mode to one of your AUX channels on the Configurator's modes tab. Once you've added a mode, Blackbox will only log flight data when the mode is active. A log header will always be recorded at arming time, even if logging is paused. You can freely pause and resume logging while in flight.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.camstab,
        name: "CAMSTAB",
        vehicleType: VehicleType.all,
        description: "Enables the servo gimbal",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.failsafe,
        name: "FAILSAFE",
        vehicleType: VehicleType.all,
        description:
            "Lets you activate flight controller failsafe with an aux channel. Read Failsafe page for more info.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.flaperon,
        name: "FLAPERON",
        vehicleType: VehicleType.all,
        description:
            "Activating it moves both ailerons down (or up) by predefined offset.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.headadj,
        name: "HEADADJ",
        vehicleType: VehicleType.all,
        description: "It allows you to set a new yaw origin for HEADFREE mode.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.headfree,
        name: "HEADFREE",
        vehicleType: VehicleType.all,
        description:
            "In this mode, the 'head' of the multicopter is always pointing to the same direction as when the feature was activated. This means that when the multicopter rotates around the Z axis (yaw), the controls will always respond according the same 'head' direction. With this mode it is easier to control the multicopter, even fly it with the physical head towards you since the controls always respond the same. This is a friendly mode to new users of multicopters and can prevent losing the control when you don't know the head direction.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.headingHold,
        name: "HEADING HOLD",
        vehicleType: VehicleType.all,
        description:
            "This flight mode affects only yaw axis and can be enabled together with any other flight mode. It helps to maintain current heading without pilots input and can be used with and without magnetometer support. When yaw stick is neutral position, Heading Hold mode tries to keep heading (azimuth if compass sensor is available) at a defined direction. When pilot moves yaw stick, Heading Hold is temporary disabled and is waiting for a new setpoint. Heading hold only uses yaw control (rudder) so it won't work on a flying wing which has no rudder.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.horizon,
        name: "HORIZON",
        vehicleType: VehicleType.all,
        description:
            "This hybrid mode works exactly like the previous ANGLE mode with centered roll and pitch sticks (thus enabling auto-leveled flight), then gradually behaves more and more like the default RATE mode as the sticks are moved away from the center position. Which means it has no limitation on banking angle and can do flips.",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.ledlow,
        name: "LEDLOW",
        vehicleType: VehicleType.all,
        description: "Turns off the RGB LEDs",
        channel: 0,
        range: RangeValues(0, 0)),
    // ModeInfo(
    //   id: FlightModeIds.aut,
    //     name: "AUTOLEVEL",
    //     vehicleType: VehicleType.wing,
    //     description:
    //         "AUTOLEVEL will attempt to automatically tune the pitch offset (fw_level_pitch_trim) a fixed-wing airplane needs to not lose altitude when flying straight in ANGLE mode.",
    //     channel: 0,
    // range: RangeValues(0,0)),
    ModeInfo(
        id: FlightModeIds.manual,
        name: "MANUAL",
        vehicleType: VehicleType.wing,
        description: "Direct servo control in fixed-wing",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.navLaunch,
        name: "NAV LAUNCH",
        vehicleType: VehicleType.wing,
        description: "Airplane launch assistant",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.osdSw,
        name: "OSD SW",
        vehicleType: VehicleType.all,
        description: "Disables the OSD",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.servoAutotrim,
        name: "SERVO AUTOTRIM",
        vehicleType: VehicleType.all,
        description:
            "In flight adjustment of servo midpoint for straight flight",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.surface,
        name: "SURFACE",
        vehicleType: VehicleType.all,
        description:
            "Enable terrain following when you have a rangefinder enabled",
        channel: 0,
        range: RangeValues(0, 0)),
    ModeInfo(
        id: FlightModeIds.turnAssist,
        name: "TURN ASSIST",
        vehicleType: VehicleType.all,
        description:
            "Normally YAW stick makes a turn around a vertical axis of the craft - this is why when you fly forward in RATE and do a 180-deg turn using only YAW you'll end up looking upwards and flying backwards. In ANGLE mode this also causes an effect known as a pirouetting where turn is not smooth the horizon line is not maintained.\n\nIn RATE mode pilot compensated for this effect by using both ROLL and YAW sticks to coordinate the rotation and keep attitude (horizon line).\n\nTURN ASSISTANT mode calculates this additional ROLL command required to maintain a coordinated YAW turn effectively making YAW stick turn the aircraft around vertical axis relative to the ground.\n\nIn RATE mode it allows one to makes a perfect yaw-stick only turn without changing attitude of the machine. There might be slight drift due to not instant response of PID control, but still much easier to pilot for a RATE-mode beginners.\n\nIn ANGLE mode it also makes yaw turns smoother and completely pirouette-less. This is because TURN ASSIST introduces feed-forward control in pitch/roll and maintains attitude naturally and without delay.",
        channel: 0,
        range: RangeValues(0, 0)),
  ];

  static List<ModeInfo> get allModes => modes;
}
