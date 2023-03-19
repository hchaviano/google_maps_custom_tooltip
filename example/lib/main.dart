import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_custom_tooltip/custom_tooltip_controller.dart';
import 'package:google_maps_custom_tooltip/google_maps_custom_tooltip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

/// main app
class MyApp extends StatelessWidget {
  /// main app
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GoogleMapExample(),
    );
  }
}

/// google map example class
class GoogleMapExample extends StatefulWidget {
  /// google map example class
  const GoogleMapExample({super.key});

  @override
  State<GoogleMapExample> createState() => _GoogleMapExampleState();
}

class _GoogleMapExampleState extends State<GoogleMapExample> {
  late Completer<GoogleMapController> _googleMapController;
  late CustomTooltipController _tootlipController;

  static const _point1 = LatLng(-24.609, 133.449);
  static const _point2 = LatLng(-26.608, 133.449);
  static const _point3 = LatLng(-21.610, 133.449);

  ///initial map camera position
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-24.609, 133.449),
    zoom: 5,
  );

  ///places to transform into markers
  static const _places = <String, LatLng>{
    'point1': _point1,
    'point2': _point2,
    'point3': _point3,
  };

  @override
  void initState() {
    _googleMapController = Completer<GoogleMapController>();
    _tootlipController = CustomTooltipController();
    super.initState();
  }

  @override
  void dispose() {
    _tootlipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (googleMapController) {
            _googleMapController.complete(googleMapController);
            ///add the google map controller
            _tootlipController.googleMapController = googleMapController;
          },
          onCameraMove: (cameraPosition) {
            ///add onCameraMoved function
            _tootlipController.onCameraMoved?.call();
          },
          markers: <Marker>{
            for (final place in _places.entries)
              Marker(
                markerId: MarkerId(place.key),
                position: place.value,
                onTap: () {
                  ///add onMarkerTapped function
                  _tootlipController.onMarkerTapped?.call(place.value);
                },
              ),
          },
        ),
        ///custom tooltip widget
        CustomTooltip(
          controller: _tootlipController,
          title: 'Tooltip Example',
        ),
      ],
    );
  }
}
