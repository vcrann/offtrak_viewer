import 'package:flutter/material.dart';
import '../models/tracker_state.dart';
import 'package:latlng/latlng.dart';
//import 'package:helixio_app/modules/helpers/service_locator.dart';

class TrackerManager extends ChangeNotifier {
  int numberOfTrackers = 0;
  List<TrackerState> trackers = [];

  void update() {
    notifyListeners();
  }

  void addTracker(String id, LatLng latLng) {
    trackers.add(TrackerState(id, latLng));
    numberOfTrackers++;
    notifyListeners();
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
