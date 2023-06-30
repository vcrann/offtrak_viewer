import 'package:latlng/latlng.dart';

class TrackerState {
  final String _id;
  int _lastUpdate = 0; // time of last update in ms since unix epoch
  int _batteryLevel = 0;
  LatLng _latLng = const LatLng(0, 0);
  TrackerState(this._id);

  void setLastUpdate() {
    _lastUpdate = DateTime.now().millisecondsSinceEpoch;
  }

  void setBatteryLevel(int batteryLevel) {
    _batteryLevel = batteryLevel;
  }

  void setGeodetic(LatLng latLng, double absoluteAltitude) {
    _latLng = latLng;
  }

  String get getID => _id;
  int get getLastUpdate => _lastUpdate;
  int get getBatteryLevel => _batteryLevel;
  LatLng get getLatLng => _latLng;
}
