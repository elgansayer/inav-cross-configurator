import 'dart:async';

import 'package:bloc/bloc.dart';
// Silly object naming
// ignore: implementation_imports
import 'package:inavconfigurator/models/mode_info.dart';
import 'package:inavconfigurator/models/mode_range.dart';
import 'package:inavconfigurator/models/vehicle_type.dart';
import 'package:inavconfigurator/msp/codes/base_data_handler.dart';
import 'package:inavconfigurator/msp/codes/box_ids.dart';
import 'package:inavconfigurator/msp/codes/box_names.dart';
import 'package:inavconfigurator/msp/codes/mode_ranges.dart';
import 'package:meta/meta.dart';

import '../../../msp/codes.dart';
import '../../../serial/serialdevice_repository.dart';

part 'modes_event.dart';
part 'modes_state.dart';

class ModesBloc extends Bloc<ModesEvent, ModesState> {
  ModesBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(ModesState.initial()) {
    this._setupListeners();
  }

  final SerialDeviceRepository _serialDeviceRepository;
  late StreamSubscription<MSPDataHandler> _streamListener;

  @override
  Future<void> close() {
    this._streamListener.cancel();
    return super.close();
  }

  @override
  Stream<ModesState> mapEventToState(
    ModesEvent event,
  ) async* {
    if (event is GotModesEvent) {
      yield this.state.copyWith(modeRanges: event.modesRanges);
      _checkBuildModes();
    }

    if (event is GotBoxIdsEvent) {
      yield this.state.copyWith(ids: event.ids);
      _checkBuildModes();
    }

    if (event is GotBoxNamesEvent) {
      yield this.state.copyWith(names: event.names);
      _checkBuildModes();
    }

    if (event is GeneratedModeInfoEvent) {
      yield this.state.copyWith(modes: event.modes);
    }

    if (event is GotAllDataEvent) {
      this._mapDataToRangeInfo();
    }
  }

  void _setupListeners() {
    this._streamListener = _serialDeviceRepository.responseStreamsAs([
      MSPCodes.mspBoxNames,
      MSPCodes.mspModeRanges,
      MSPCodes.mspBoxIds
    ]).listen((messageResponse) {
      if (messageResponse is MSPModeRanges) {
        this.add(GotModesEvent(modesRanges: messageResponse.modes));
      }

      if (messageResponse is MSPBoxNames) {
        this.add(GotBoxNamesEvent(names: messageResponse.names));
      }

      if (messageResponse is MSPBoxIds) {
        this.add(GotBoxIdsEvent(ids: messageResponse.ids));
      }
    });

    _writeModes();
  }

  void _writeModes() {
    try {
      _serialDeviceRepository.writeFunc(MSPCodes.mspBoxNames);
      _serialDeviceRepository.writeFunc(MSPCodes.mspModeRanges);
      _serialDeviceRepository.writeFunc(MSPCodes.mspBoxIds);

      // MSP_CF_SERIAL_CONFIG
      // MSPCodes.MSP_RC
      // sort_modes_for_display
    } catch (e) {
      this.close();
    }
  }

  _checkBuildModes() {
    bool haveIds = this.state.ids.length > 0;
    bool haveNames = this.state.names.length > 0;
    bool haveModeRanges = this.state.modeRanges.length > 0;

    if (haveIds && haveNames && haveModeRanges) {
      this.add(GotAllDataEvent());
    }
  }

  void _mapDataToRangeInfo() {
    int base = 5;

    List<ModeInfo> allModes = [];
    for (var i = 0; i < this.state.ids.length; i++) {
      int id = this.state.ids[i];
      String name = this.state.names[i];
      ModeRange range = this.state.modeRanges[i];

      if (range.range.start >= range.range.end) {
        continue;
      }

      ModeInfo newMode = ModeInfo(
          channel: range.auxChannelIndex + base,
          range: range.range,
          description: '',
          id: id,
          name: name,
          vehicleType: VehicleType.all);

      allModes.add(newMode);
    }

    this.add(GeneratedModeInfoEvent(modes: allModes));

    // var allModes = FlightModes.allModes;

    // List<ModeInfo> modeInfos = [];

    // for (var modeRange in modesRanges) {
    //   var id = modeRange.id;

    //   var foundModes = allModes.where((modeInfo) => modeInfo.id == id);

    //   if (foundModes.length < 1) {
    //     continue;
    //   }
    //   var foundMode = foundModes.elementAt(0);

    //   ModeInfo newMode = foundMode.copyWith(
    //       channel: modeRange.auxChannelIndex, range: modeRange.range);

    //   modeInfos.add(newMode);
    // }
  }
}
