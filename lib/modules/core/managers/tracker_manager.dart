import 'package:flutter/material.dart';
import '../models/tracker_state.dart';
import 'package:latlng/latlng.dart';

class TrackerManager extends ChangeNotifier {
  List<TrackerState> trackers = [];
  int timeout =
      60 * 1000; // time in ms before a tracker is considered timed out

  void update() {
    notifyListeners();
  }

  void checkTimedOutTrackers() {
    List<TrackerState> trackersToRemove = [];
    for (TrackerState tracker in trackers) {
      if (tracker.getLastUpdate <
          DateTime.now().millisecondsSinceEpoch - timeout) {
        trackersToRemove.add(tracker);
      }
    }
    for (TrackerState tracker in trackersToRemove) {
      trackers.remove(tracker);
    }
    notifyListeners();
  }

  void handleDataMessage(int id, int gpsTime, LatLng latLng, double altitude) {
    bool newTracker = true;
    for (TrackerState tracker in trackers) {
      if (tracker.getID == id) {
        tracker.update(gpsTime, latLng, altitude);
        newTracker = false;
      }
    }
    if (newTracker) {
      trackers.add(TrackerState(id));
      trackers.last.update(gpsTime, latLng, altitude);
    }
    notifyListeners();
  }
}
