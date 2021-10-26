import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:dart_periphery/dart_periphery.dart';
import 'package:inavconfigurator/msp/msp_message.dart';
import 'package:libserialport/libserialport.dart';

extension IndexOfElements<T> on List<T> {
  int indexOfElements(List<T> elements, [int start = 0]) {
    if (elements.isEmpty) return -1;
    var end = length - elements.length;
    if (start > end) return -1;
    var first = elements.first;
    var pos = start;
    while (true) {
      pos = indexOf(first, pos);
      if (pos < 0 || pos > end) return -1;
      for (var i = 1; i < elements.length; i++) {
        if (this[pos + i] != elements[i]) {
          pos++;
          continue;
        }
      }
      return pos;
    }
  }
}

class SerialDeviceProvider {
  SerialDeviceProvider();

  final int timeout = 5000;

  late bool _blockRead;
  final StreamController<List<int>> _readStream =
      new StreamController<List<int>>();

  late Serial _serial;
  late Timer _streamTimer;
  final identifier = new Queue<int>();

  Stream<List<int>> get data => _readStream.stream;

  bool connect(String path) {
    this._serial = Serial(path, Baudrate.B115200);
    try {
      print('Connecting to $path');

      this._blockRead = false;
      // int lemon = this._serial.writeString('Y\r\n');

      print('Serial interface info: ' + this._serial.getSerialInfo());

      // var event = this._serial.read(0, -1);
      // print('Response ${event.toString()}');
      // for (var i = 0; i < 5; ++i) {
      //   this._serial.writeString('Q\r\n');
      //   event = this._serial.read(256, 1000);
      //   print(event.toString());
      //   sleep(Duration(seconds: 5));
      // }

      Duration timerDuration = Duration(milliseconds: 1);
      this._streamTimer = Timer.periodic(timerDuration, this._readPoll);
    } catch (e) {
      print(this._serial.getErrno());
      print(e);
      this._serial.dispose();
    }
    return true;
  }

  int write(List<int> list) {
    int written = this._serial.write(list);
    // this._serial.flush();
    // this._doReadPoll();
    return written;
  }

  int writeString(String data) {
    var written = this._serial.writeString(data);
    return written;
  }

  _readPoll(Timer timer) {
    this._doReadPoll();
  }

  late bool _packetLocak = false;
  _findPackets() async {
    if (this._packetLocak) {
      return;
    }
    this._packetLocak = true;
    List<int> allData = identifier.toList();
    if (allData.length <= 0) {
      this._packetLocak = false;

      return;
    }

    List<int> header = [36, 88, 62, 0];
    print("identifier.length before ${identifier.length}");

    // 36, 88, 62, 0,
    int hasHeader = allData.indexOfElements(header);

    if (hasHeader > -1) {
      int l = allData[6];
      l |= allData[7] << 8;

      int p = 8 + l + 1;

      List<int> subData = allData.sublist(hasHeader, hasHeader + p);
      if (subData.length > 0) {
        _readStream.add(subData);
      }

      for (var i = 0; i < hasHeader + subData.length; i++) {
        identifier.removeFirst();
      }
    }
    print("identifier.length after ${identifier.length}");
    this._packetLocak = false;

    // if (hasHeader > 0) {
    //   int start = 0;
    //   hasHeader += 4;
    //   while (hasHeader >= 0) {
    //     List<int> subData =
    //         allData.sublist(start, hasHeader == 0 ? allData.length : hasHeader);

    //     if (subData.length > 0) {
    //       _readStream.add(subData);
    //     }

    //     if (hasHeader == 0) {
    //       break;
    //     }

    //     start = hasHeader;
    //     int end = ((allData.length));
    //     hasHeader = allData.sublist(start, end).indexOfElements(header);
    //   }
    // } else {
    //   if (allData.length > 0) {
    //     _readStream.add(allData);
    //   }
    // }
  }

  _doReadPoll() {
    try {
      _findPackets();
      int waiting = this._serial.getInputWaiting();

      if (this._blockRead || waiting <= 0) {
        return;
      }

      this._blockRead = true;

      List<int> allData = [];
      while (waiting > 0) {
        SerialReadEvent data = this._serial.read(waiting, 0);
        allData.addAll(data.data);
        waiting = this._serial.getInputWaiting();
      }

      identifier.addAll(allData);
    } catch (e) {
      if (e is SerialPortError &&
          e.errorCode == SerialErrorCode.SERIAL_ERROR_IO.index) {
        this.close();
      }

      print(e);
    }

    this._blockRead = false;
  }

  close() {
    print("Closing serial device");
    _readStream.close();
    this._streamTimer.cancel();
  }

  disconnect() {
    this.close();
  }
}
