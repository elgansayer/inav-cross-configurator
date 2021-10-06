abstract class MSPCodes {
  // Gets API version
  static int mspApiVersion = 1;
  // Gets FC String name
  static int mspFcVariant = 2;
  // Gets FC Inav version
  static int mspFcVersionu = 3;
  static int mspBoardInfo = 4;
  static int mspBuildInfo = 5;

  static int mspInavPid = 6;
  static int mspSetInavPid = 7;

  static int mspName = 10;
  static int mspSetName = 11;

  static int mspNavPoshold = 12;
  static int mspSetNavPoshold = 13;
  static int mspCalibrationData = 14;
  static int mspSetCalibrationData = 15;

  static int mspPositionEstimationConfig = 16;
  static int mspSetPositionEstimationConfig = 17;
  static int mspWpMissionLoad = 18;
  static int mspWpMissionSave = 19;
  static int mspWpGetinfo = 20;
  static int mspRthAndLandConfig = 21;
  static int mspSetRthAndLandConfig = 22;
  static int mspFwConfig = 23;
  static int mspSetFwConfig = 24;

  // static int msp commands for cleanflight original features
  static int mspChannelForwarding = 32;
  static int mspSetChannelForwarding = 33;
  static int mspModeRanges = 34;
  static int mspSetModeRange = 35;
  static int mspRxConfig = 44;
  static int mspSetRxConfig = 45;
  static int mspLedColors = 46;
  static int mspSetLedColors = 47;
  static int mspLedStripConfig = 48;
  static int mspSetLedStripConfig = 49;
  static int mspAdjustmentRanges = 52;
  static int mspSetAdjustmentRange = 53;
  static int mspCfSerialConfig = 54;
  static int mspSetCfSerialConfig = 55;
  static int mspSonar = 58;
  static int mspPidController = 59;
  static int mspSetPidController = 60;
  static int mspArmingConfig = 61;
  static int mspSetArmingConfig = 62;
  static int mspDataflashSummary = 70;
  static int mspDataflashRead = 71;
  static int mspDataflashErase = 72;
  static int mspLoopTime = 73;
  static int mspSetLoopTime = 74;
  static int mspFailsafeConfig = 75;
  static int mspSetFailsafeConfig = 76;
  static int mspRxfailConfig = 77;
  static int mspSetRxfailConfig = 78;
  static int mspSdcardSummary = 79;
  static int mspBlackboxConfig = 80;
  static int mspSetBlackboxConfig = 81;
  static int mspTransponderConfig = 82;
  static int mspSetTransponderConfig = 83;
  static int mspOsdConfig = 84;
  static int mspSetOsdConfig = 85;
  static int mspOsdCharRead = 86;
  static int mspOsdCharWrite = 87;
  static int mspVtxConfig = 88;
  static int mspSetVtxConfig = 89;
  static int mspAdvancedConfig = 90;
  static int mspSetAdvancedConfig = 91;
  static int mspFilterConfig = 92;
  static int mspSetFilterConfig = 93;
  static int mspPidAdvanced = 94;
  static int mspSetPidAdvanced = 95;
  static int mspSensorConfig = 96;
  static int mspSetSensorConfig = 97;

  // multiwii static int msp commands
  static int mspIdent = 100; //deprecated; do not use
  static int mspStatus = 101;
  static int mspRawImu = 102;
  static int mspServo = 103;
  static int mspMotor = 104;
  static int mspRc = 105;
  static int mspRawGps = 106;
  static int mspCompGps = 107;
  // Gets pitch, yaw, roll
  static int mspAttitude = 108;
  static int mspAltitude = 109;
  static int mspAnalog = 110;
  static int mspRcTuning = 111;
  static int mspPid = 112;
  static int mspActiveboxes = 113;
  static int mspMisc = 114;
  static int mspMotorPins = 115;
  static int mspBoxNames = 116;
  static int mspPidnames = 117;
  static int mspWp = 118;
  static int mspBoxIds = 119;
  static int mspServoConfigurations = 120;
  static int msp3d = 124;
  static int mspRcDeadband = 125;
  static int mspSensorAlignment = 126;
  static int mspLedStripModecolor = 127;
  // cycleTime, i2cError, activeSensors, profile, cpuload, armingFlags
  static int mspStatusEx = 150;
  static int mspSensorStatus = 151;

  static int mspSetRawRc = 200;
  static int mspSetRawGps = 201;
  static int mspSetPid = 202;
  static int mspSetBox = 203;
  static int mspSetRcTuning = 204;
  static int mspAccCalibration = 205;
  static int mspMagCalibration = 206;
  static int mspSetMisc = 207;
  static int mspResetConf = 208;
  static int mspSetWp = 209;
  static int mspSelectSetting = 210;
  static int mspSetHead = 211;
  static int mspSetServoConfiguration = 212;
  static int mspSetMotor = 214;
  static int mspSet3d = 217;
  static int mspSetRcDeadband = 218;
  static int mspSetResetCurrPid = 219;
  static int mspSetSensorAlignment = 220;
  static int mspSetLedStripModecolor = 221;

  // static int mspBind =        240;

  static int mspServoMixRules = 241;
  static int mspSetServoMixRule = 242;

  static int mspRtc = 246;
  static int mspSetRtc = 247;

  static int mspEepromWrite = 250;

  static int mspDebugmsg = 253;
  static int mspDebug = 254;

  // additional baseflight commands that are not compatible with multiwii
  static int mspUid = 160; // unique device id
  static int mspAccTrim = 240; // get acc angle trim values
  static int mspSetAccTrim = 239; // set acc angle trim values
  static int mspGpsSvInfo = 164; // get signal strength
  static int mspGpsstatistics = 166; // gps statistics

  // additional private static int msp for baseflight configurator (yes thats us \o/)
  // get channel map (also returns number of channels total)
  static int mspRxMap = 64;
  // set rc map; numchannels to set comes from static int mspRxMap
  static int mspSetRxMap = 65;
  // baseflight-specific settings that aren't covered elsewhere
  static int mspBfConfig = 66;
  // baseflight-specific settings save
  static int mspSetBfConfig = 67;
  // reboot settings
  static int mspSetReboot = 68;
  // build date as well as some space for future expansion
  static int mspBfBuildInfo = 69;

  // inav specific codes
  static int mspv2Setting = 0x1003;
  static int mspv2SetSetting = 0x1004;

  static int msp2CommonMotorMixer = 0x1005;
  static int msp2CommonSetMotorMixer = 0x1006;

  static int msp2CommonSettingInfo = 0x1007;
  static int msp2CommonPgList = 0x1008;

  static int msp2CfSerialConfig = 0x1009;
  static int msp2SetCfSerialConfig = 0x100a;

  // cycleTime, i2cError, activeSensors, profile, cpuload, armingFlags
  static int mspv2InavStatus = 8192; //0x2000;
  static int mspv2InavOpticalFlow = 0x2001;
  static int mspv2InavAnalog = 0x2002;
  static int mspv2InavMisc = 0x2003;
  static int mspv2InavSetMisc = 0x2004;
  static int mspv2InavBatteryConfig = 0x2005;
  static int mspv2InavSetBatteryConfig = 0x2006;
  static int mspv2InavRateProfile = 0x2007;
  static int mspv2InavSetRateProfile = 0x2008;
  static int mspv2InavAirSpeed = 0x2009;
  static int mspv2InavOutputMapping = 0x200a;

  static int msp2InavMixer = 0x2010;
  static int msp2InavSetMixer = 0x2011;

  static int msp2InavOsdLayouts = 0x2012;
  static int msp2InavOsdSetLayoutItem = 0x2013;
  static int msp2InavOsdAlarms = 0x2014;
  static int msp2InavOsdSetAlarms = 0x2015;
  static int msp2InavOsdPreferences = 0x2016;
  static int msp2InavOsdSetPreferences = 0x2017;

  static int msp2InavMcBraking = 0x200b;
  static int msp2InavSetMcBraking = 0x200c;

  static int msp2InavSelectBatteryProfile = 0x2018;

  static int msp2InavDebug = 0x2019;

  static int msp2BlackboxConfig = 0x201a;
  static int msp2SetBlackboxConfig = 0x201b;

  static int msp2InavTempSensorConfig = 0x201c;
  static int msp2InavSetTempSensorConfig = 0x201d;
  static int msp2InavTemperatures = 0x201e;

  static int msp2InavServoMixer = 0x2020;
  static int msp2InavSetServoMixer = 0x2021;
  static int msp2InavLogicConditions = 0x2022;
  static int msp2InavSetLogicConditions = 0x2023;
  static int msp2InavGlobalFunctions = 0x2024;
  static int msp2InavSetGlobalFunctions = 0x2025;
  static int msp2InavLogicConditionsStatus = 0x2026;
  static int msp2InavGvarStatus = 0x2027;
  static int msp2InavProgrammingPid = 0x2028;
  static int msp2InavSetProgrammingPid = 0x2029;
  static int msp2InavProgrammingPidStatus = 0x202a;

  static int msp2Pid = 0x2030;
  static int msp2SetPid = 0x2031;

  static int msp2InavOpflowCalibration = 0x2032;

  static int msp2InavFwupdtPrepare = 0x2033;
  static int msp2InavFwupdtStore = 0x2034;
  static int msp2InavFwupdtExec = 0x2035;
  static int msp2InavFwupdtRollbackPrepare = 0x2036;
  static int msp2InavFwupdtRollbackExec = 0x2037;

  static int msp2InavSafehome = 0x2038;
  static int msp2InavSetSafehome = 0x2039;
}
