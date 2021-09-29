import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:inavconfigurator/home/modes/modes.dart';
// Silly object naming
// ignore: implementation_imports
import 'package:inavconfigurator/models/mode_info.dart';
import 'package:inavconfigurator/models/mode_range.dart';
import 'package:inavconfigurator/msp/codes/mode_ranges.dart';
import 'package:meta/meta.dart';

import '../../../msp/codes.dart';
import '../../../msp/mspmessage.dart';
import '../../../serial/serialdevice_repository.dart';

part 'modes_event.dart';
part 'modes_state.dart';

class ModesBloc extends Bloc<ModesEvent, ModesState> {
  final SerialDeviceRepository _serialDeviceRepository;
  late StreamSubscription<MSPMessageResponse> _streamListener;

  ModesBloc({required SerialDeviceRepository serialDeviceRepository})
      : _serialDeviceRepository = serialDeviceRepository,
        super(ModesInitial()) {
    this._setupListeners();
  }

  @override
  Stream<ModesState> mapEventToState(
    ModesEvent event,
  ) async* {
    if (event is GotModesEvent) {
      yield* _mapModeRangesToInfo(event.modesRanges);
    }
  }

  void _setupListeners() {
    this._streamListener = _serialDeviceRepository
        .responseStreams(MSPCodes.mspModeRanges)
        .listen((messageResponse) {
      MSPModeRanges? rawModes = _serialDeviceRepository.transform(
          MSPCodes.mspModeRanges, messageResponse);

      if (rawModes == null) {
        return;
      }

      this.add(GotModesEvent(modesRanges: rawModes.modes));
    });

    _serialDeviceRepository.responseRaw.listen((Uint8List data) {
      if (data == data) {
        return;
      }
    });
    _writeModes();
  }

  void _writeModes() async {
    try {
      _serialDeviceRepository.writeFunc(MSPCodes.mspModeRanges);
    } catch (e) {
      this.close();
    }
  }

  @override
  Future<void> close() {
    this._streamListener.cancel();
    return super.close();
  }

  _mapModeRangesToInfo(List<ModeRange> modesRanges) async* {
    var allModes = FlightModes.allModes;

    List<ModeInfo> modeInfos = [];

    for (var modeRange in modesRanges) {
      var id = modeRange.id;

      ModeInfo? foundMode =
          allModes.firstWhere((modeInfo) => modeInfo.id == id, orElse: null);

      // if (foundMode == null) {
      //   continue;
      // }

      ModeInfo newMode = foundMode.copyWith(
          channel: modeRange.auxChannelIndex, range: modeRange.range);

      modeInfos.add(newMode);
    }

    yield ModesAvailableState(modes: modeInfos);

    // modesRanges.map((modesRange) {
    //   var id = modesRange.id;

    //   ModeInfo mode =
    //       allModes.firstWhere((modeInfo) => modeInfo.id == id, orElse: null);

    //   if (mode != null) {
    //     return mode.copyWith(
    //         channel: modesRange.auxChannelIndex, range: modesRange.range);
    //   }
    // }).toList();
  }
}
