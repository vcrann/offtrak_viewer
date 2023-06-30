import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialManager extends ChangeNotifier {
  void update() {
    notifyListeners();
  }

  Future<void> openConnection(String portName, int baud) async {
    SerialPort port = SerialPort(portName);
    final serialConfig = SerialPortConfig();
    serialConfig.baudRate = baud;
    port.config = serialConfig;
    SerialPortReader reader = SerialPortReader(port, timeout: 60);
    try {
      port.openReadWrite();
      await reader.stream.listen((data) {
        //TODO decode this from the relevant format and send it over to tracker manager
        print('received : $data');
      });
    } on SerialPortError catch (_, err) {
      if (port.isOpen) {
        port.close();
        print('serial port error');
      }
    }

    List<double> decodeTelemetry(String telemetry) {
      //converts strings to doubles
      var stringArray = telemetry.split(', ');

      List<double> doubleArray = [];
      for (int i = 0; i < stringArray.length; i++) {
        doubleArray.add(double.parse(stringArray[i]));
      }

      return doubleArray;
    }
  }
}
