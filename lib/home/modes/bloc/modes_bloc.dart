import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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

class ModeRangeValues {
  static double max = 2100;
  static double min = 900;

  static double get distance => (ModeRangeValues.max - ModeRangeValues.min);

  static double get mid => ModeRangeValues.distance / 2;
}

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

    if (event is AddNewModesEvent) {
      yield* this._mapNewModesToState(event.modes);
    }

    if (event is RemoveModeEvent) {
      yield* this._mapRemoveModesToState(event.mode);
    }

    if (event is ChangeChannelEvent) {
      yield* this._mapChangeChannelToState(event.mode, event.channel);
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
  }

  Stream<ModesState> _mapNewModesToState(List<ModeInfo> modes) async* {
    List<ModeInfo> oldModes = this.state.modes;
    List<ModeInfo> newModes = List<ModeInfo>.from(oldModes);

    double distance = ModeRangeValues.mid / 10;
    double start = ModeRangeValues.min + ModeRangeValues.mid - distance;
    double end = ModeRangeValues.min + ModeRangeValues.mid + distance;

    List<ModeInfo> newModeInfos = modes.map((mode) {
      return mode.copyWith(range: RangeValues(start, end));
    }).toList();

    newModes.addAll(newModeInfos);

    yield this.state.copyWith(modes: newModes);
  }

  Stream<ModesState> _mapRemoveModesToState(ModeInfo mode) async* {
    List<ModeInfo> oldModes = this.state.modes;
    List<ModeInfo> newModes = List<ModeInfo>.from(oldModes);
    newModes.remove(mode);
    yield this.state.copyWith(modes: newModes);
  }

  Stream<ModesState> _mapChangeChannelToState(
      ModeInfo mode, int channel) async* {
    List<ModeInfo> oldModes = this.state.modes;
    List<ModeInfo> newModes = oldModes.map((ModeInfo oldMode) {
      if (oldMode != mode) {
        return oldMode;
      }
      return oldMode.copyWith(channel: channel);
    }).toList();

    yield this.state.copyWith(modes: newModes);
  }
}
