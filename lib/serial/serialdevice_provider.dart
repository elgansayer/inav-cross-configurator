import 'package:inavconfiurator/msp/codes.dart';
import 'package:inavconfiurator/msp/mspmessage.dart';
import 'package:libserialport/libserialport.dart';

class SerialDeviceProvider {
  SerialDeviceProvider();

  SerialPort? open(String portWanted) {
    SerialPort serialPort = SerialPort(portWanted);

    if (!serialPort.openReadWrite()) {
      serialPort.close();
      return null;
    }

    final reader = SerialPortReader(serialPort);

    reader.stream.listen((data) {
      MSPMessageResponse response = MSPMessageResponse(data);
      var pData = response.payload;
      print(pData);
      print(data);
    });

    MSPMessageRequest request = MSPMessageRequest(MSPCodes.mspApiVersion);
    request.write(serialPort);

    // Version?
    // var data = serialPort.read(request.payload.length);
    // print(data);

    // MSPMessageRequest request = MSPMessageRequest(MSPCodes.mspFcVersionu);
    // serialPort.write(request.payload);

    return serialPort;
  }
}

class MSPProvider {}
