import 'package:flutter/material.dart';
import 'package:offtrak_viewer/modules/core/managers/tracker_manager.dart';
import 'package:latlng/latlng.dart';
import 'package:offtrak_viewer/modules/helpers/service_locator.dart';
import 'package:udp/udp.dart';
import 'dart:io';

class UDPManager extends ChangeNotifier {
  bool isConnected =
      false; // used to check if the port variable has been assigned

  void update() {
    notifyListeners();
  }

  void decodeUDPData(String dataString) {
    dataString.replaceAll(' ', '');
    dataString.replaceAll('\n', '');
    var dataList = dataString.split(',');

    if (dataList[2] == 'MLGPS') {
      print('received : $dataString');
      int id = int.parse(dataList[0]);
      int gpsTime = int.parse(dataList[1]);
      String messageType = dataList[2];
      double latitude = int.parse(dataList[3]).toDouble() / 10000000.0;
      double longitude = int.parse(dataList[4]).toDouble() / 10000000.0;
      double altitude = int.parse(dataList[5]).toDouble() / 1000.0;

      serviceLocator<TrackerManager>().handleDataMessage(
          id, gpsTime, LatLng(latitude, longitude), altitude);
    }
  }

  void openUDPConnection() async {
    // creates a new UDP instance and binds it to the local address and the port
    // 65002.
    print('UDP connection opened');
    //var receiver = await UDP.bind(Endpoint.loopback(port: Port(10101)));
    var receiver = await UDP.bind(
        Endpoint.unicast(InternetAddress('172.16.0.255'), port: Port(10101)));

    // receiving\listening
    receiver.asStream().listen((datagram) {
      var dataString = String.fromCharCodes(datagram!.data);
      print(dataString);
      decodeUDPData(dataString);
    });

    // close the UDP instances and their sockets.
    //receiver.close();
  }
}
