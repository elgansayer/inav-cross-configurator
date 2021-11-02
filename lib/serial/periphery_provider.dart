import 'dart:async';
import 'dart:collection';

import 'package:dart_periphery/dart_periphery.dart';
import 'package:inavconfigurator/serial/list_index.dart';
import 'package:libserialport/libserialport.dart';

class SerialDeviceProviderPeriphery {
  SerialDeviceProviderPeriphery();

  final int timeout = 5000;

  late bool _blockRead;
  // final StreamController<List<int>> _readStream =
  //     new StreamController<List<int>>();

  final StreamController<List<int>> _dataStream =
      new StreamController<List<int>>();

  late Serial _serial;
  late Timer _streamTimer;
  // final identifier = new Queue<int>();
  // Stream<List<int>> get data => _readStream.stream;

  Stream<List<int>> get dataStream => _dataStream.stream;
  StreamSink<List<int>> get dataSink => _dataStream.sink;

  bool connect(String path) {
    this._serial = Serial(path, Baudrate.B115200);
    try {
      print('Connecting to $path');

      this._blockRead = false;
      // int lemon = this._serial.writeString('Y\r\n');

      print('Serial interface info: ' + this._serial.getSerialInfo());

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

  // late bool _packetLocak = false;
  // _findPackets() async {
  //   if (this._packetLocak) {
  //     return;
  //   }
  //   this._packetLocak = true;
  //   List<int> allData = identifier.toList();
  //   if (allData.length <= 0) {
  //     this._packetLocak = false;
  //     return;
  //   }

  //   List<int> header = [36, 88, 62, 0];
  //   print("identifier.length before ${identifier.length}");

  //   // 36, 88, 62, 0,
  //   int hasHeader = allData.indexOfElements(header);

  //   if (hasHeader > -1) {
  //     int l = allData[6];
  //     l |= allData[7] << 8;

  //     int p = 8 + l + 1;

  //     List<int> subData = allData.sublist(hasHeader, hasHeader + p);
  //     if (subData.length > 0) {
  //       _readStream.add(subData);
  //     }

  //     for (var i = 0; i < hasHeader + subData.length; i++) {
  //       identifier.removeFirst();
  //     }
  //   }
  //   print("identifier.length after ${identifier.length}");
  //   this._packetLocak = false;
  // }

  _doReadPoll() {
    try {
      // _findPackets();
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

      dataSink.add(allData);
      // identifier.addAll(allData);
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
    // _readStream.close();
    this._streamTimer.cancel();
  }

  disconnect() {
    this.close();
  }

  void drain() {}

  void flush() {
    this._serial.flush();
  }

  int getInputWaiting() {
    return this._serial.getInputWaiting();
  }

  List<int> read(int waiting, int timeout) {
    SerialReadEvent data = this._serial.read(waiting, timeout);
    return data.data;
  }
}
