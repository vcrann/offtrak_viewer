import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:offtrak_viewer/modules/core/managers/tracker_manager.dart';
import 'package:latlng/latlng.dart';
import 'package:offtrak_viewer/modules/helpers/service_locator.dart';

class SerialManager extends ChangeNotifier {
  late SerialPort port;
  bool isConnected =
      false; // used to check if the port variable has been assigned

  void update() {
    notifyListeners();
  }

  void decodeSerialData(String dataString) {
    if (validateSerialData(dataString)) {
      int id = int.parse(getSubstringBetween(dataString, "TagID(", ")"));
      int gpsTime = int.parse(getSubstringBetween(dataString, "GPSTime(", ")"));
      double latitude =
          double.parse(getSubstringBetween(dataString, "Lat(", ")"));
      double longitude =
          double.parse(getSubstringBetween(dataString, "Lon(", ")"));
      double altitude =
          double.parse(getSubstringBetween(dataString, "Alt(", ")"));

      serviceLocator<TrackerManager>().handleDataMessage(
          id, gpsTime, LatLng(latitude, longitude), altitude);
    }
  }

  Future<void> openConnection(String portName, int baud) async {
    port = SerialPort(portName);
    final serialConfig = SerialPortConfig();
    serialConfig.baudRate = baud;
    port.config = serialConfig;
    SerialPortReader reader = SerialPortReader(port, timeout: 60);
    isConnected = true;
    try {
      port.openReadWrite();
      await reader.stream.listen((data) {
        //TODO decode this from the relevant format and send it over to tracker manager
        print('received : $data');
        String dataString = String.fromCharCodes(data);
        decodeSerialData(dataString);
      });
    } on SerialPortError catch (_, err) {
      if (port.isOpen) {
        isConnected = false;
        port.close();
        print('serial port error');
      }
    }
  }

  void closeConnection() {
    if (isConnected) {
      if (port.isOpen) {
        port.close();
        print('serial port error');
      }
    }
  }
}

// utlility functions
bool validateSerialData(String dataString) {
  if (dataString.contains("TagID(") &&
      dataString.contains("GPSTime(") &&
      dataString.contains("Lat(") &&
      dataString.contains("Lon(") &&
      dataString.contains("Alt(")) {
    return true;
  } else {
    return false;
  }
}

String getSubstringBetween(String str, String start, String end) {
  final startIndex = str.indexOf(start);
  final endIndex = str.indexOf(end, startIndex + start.length);

  return str.substring(startIndex + start.length, endIndex);
}
