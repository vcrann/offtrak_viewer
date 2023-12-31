import 'package:flutter/material.dart';
//import 'package:helixio_app/pages/page_scaffold.dart';
import 'package:offtrak_viewer/modules/core/secrets/keys.dart';
import 'package:offtrak_viewer/modules/helpers/service_locator.dart';
import 'package:offtrak_viewer/modules/core/managers/tracker_manager.dart';
import 'package:offtrak_viewer/modules/core/models/tracker_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);
  //final SwarmManager swarmManager;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final controller = MapController(
    location: LatLng(52.81651946850575, -4.124781265539541),
  );

  bool _darkMode = false;

  List<TrackerMarker> _generateMarkers(
      var trackers, MapTransformer transformer) {
    List<TrackerMarker> trackerMarkers = [];

    if (trackers.isNotEmpty) {
      for (TrackerState tracker in trackers) {
        trackerMarkers.add(TrackerMarker(
            tracker.getLatLng,
            transformer.toOffset(tracker.getLatLng),
            "ID: ${tracker.getID} \n Alt: ${tracker.getAltitude}"));
      }
    }
    return trackerMarkers;
  }

  void _gotoDefault() {
    controller.center = const LatLng(53.43578053111544, -2.250343561172483);
    setState(() {});
  }

  Future<void> _getUserLocation() async {
    print("getting location");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    controller.center = LatLng(position.latitude, position.longitude);
    print("latitude= " + position.latitude.toString());
    print("longitude= " + position.longitude.toString());
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.zoom = 16.5;
    setState(() {});
  }

  // void _setInitialZoom() {
  //   controller.zoom = 10;
  //   setState(() {});
  // }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, MapTransformer transformer) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      transformer.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color, String text) {
    return Positioned(
        left: pos.dx - 100,
        top: pos.dy - 100,
        width: 200,
        height: 200,
        // child: Row(
        //   children: [
        //     const Text('SXXX'),
        //     Icon(Icons.airplanemode_active, color: color),
        //   ],
        // ),
        child: Row(
          children: <Widget>[
            //Expanded(
            //  child: Icon(Icons.person, color: color, size: 30),
            //),
            Expanded(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    //print('drawing map');

    return Stack(children: [
      MapLayout(
        controller: controller,
        builder: (context, transformer) {
          final centerLocation = Offset(
              transformer.constraints.biggest.width / 2,
              transformer.constraints.biggest.height / 2);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: (details) => _onScaleUpdate(details, transformer),
            onTapUp: (details) {
              final location = transformer.toLatLng(details.localPosition);

              final clicked = transformer.toOffset(location);

              print('${location.longitude}, ${location.latitude}');
              print('${clicked.dx}, ${clicked.dy}');
              print('${details.localPosition.dx}, ${details.localPosition.dy}');
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  TileLayer(
                    builder: (context, x, y, z) {
                      final tilesInZoom = pow(2.0, z).floor();

                      while (x < 0) {
                        x += tilesInZoom;
                      }
                      while (y < 0) {
                        y += tilesInZoom;
                      }

                      x %= tilesInZoom;
                      y %= tilesInZoom;
                      //Mapbox Streets
                      final url =
                          'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/$z/$x/$y?access_token=$mapBoxApiKey';

                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  // used to update markers at set frequency rather than as fast as updates are received
                  // increases performance
                  TimerBuilder.periodic(const Duration(milliseconds: 5000),
                      builder: (context) {
                    //print("rebuilding markers");
                    serviceLocator<TrackerManager>().checkTimedOutTrackers();
                    var trackers = serviceLocator<TrackerManager>().trackers;

                    final markerPositions =
                        _generateMarkers(trackers, transformer);

                    final markerWidgets = markerPositions.map(
                      (trackerMarker) => _buildMarkerWidget(
                        trackerMarker.cartesian,
                        Colors.red,
                        trackerMarker.text,
                      ),
                    );
                    return Stack(
                      children: [...markerWidgets],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Ink(
            decoration: const ShapeDecoration(
              color: Colors.lightBlue,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.my_location),
              color: Colors.white,
              onPressed: () {
                _getUserLocation();
              },
            ),
          ),
        ),
      ),
    ]);
  }
}

// Defines marker object containing position and heading
class TrackerMarker {
  final LatLng latLng;
  final Offset cartesian;
  final String text;

  TrackerMarker(this.latLng, this.cartesian, this.text);
}
