import 'package:flutter/material.dart';
import '../models/tracker_state.dart';
//import 'package:helixio_app/modules/helpers/service_locator.dart';

class TrackerManager extends ChangeNotifier {
  int numberOfTrackers = 0;
  List<TrackerState> trackers = []; // linter prefers this to map

  void update() {
    notifyListeners();
  }

  void addTracker(String id) {
    trackers.add(TrackerState(id));
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
