import 'package:latlng/latlng.dart';

class TrackerState {
  final int _id;
  int _lastUpdate = 0; // time of last update in ms since unix epoch
  int _batteryLevel = 0;
  LatLng _latLng = const LatLng(0, 0);
  double _altitude = 0;
  //TrackerState(this._id);
  TrackerState(this._id);

  void update(int gpsTime, LatLng latLng, double altitude) {
    setLastUpdate();
    _latLng = latLng;
    _altitude = altitude;
  }

  void setLastUpdate() {
    _lastUpdate = DateTime.now().millisecondsSinceEpoch;
  }

  int get getID => _id;
  int get getLastUpdate => _lastUpdate;
  int get getBatteryLevel => _batteryLevel;
  LatLng get getLatLng => _latLng;
  double get getAltitude => _altitude;
}
