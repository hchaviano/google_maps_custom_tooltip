import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A controller for the CustomTooltip widget that provides
/// access to the [GoogleMapController] and allows for setting
/// callback functions for when a marker is tapped or the camera is moved.

class CustomTooltipController {
  /// Creates a [CustomTooltipController] instance.
  ///
  /// The [googleMapController] parameter is required, while
  /// the [onMarkerTapped] and [onCameraMoved] parameters are optional
  /// callback functions that can be set to handle the corresponding events.

  CustomTooltipController({
    this.googleMapController,
    this.onMarkerTapped,
    this.onCameraMoved,
  });

  /// The [GoogleMapController] instance.
  late GoogleMapController? googleMapController;

  /// A callback function that is called when a marker is tapped.
  late Function(LatLng)? onMarkerTapped;

  /// A callback function that is called when the camera is moved.
  late VoidCallback? onCameraMoved;

  /// Disposes of the [googleMapController].
  void dispose() {
    googleMapController?.dispose();
  }
}
