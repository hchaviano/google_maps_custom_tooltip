# Custom Tooltip for Google Maps

This package provides a custom tooltip widget that appears above a marker in a Google Map. 
The tooltip contains a title and an optional body and is fully customizable.

|             | Android | iOS   | Linux | macOS  | Web | Windows     |
|-------------|---------|-------|-------|--------|-----|-------------|
| **Support** | SDK 16+ | 11.0+ | Any   | 10.11+ | Any | Windows 10+ |

## Installation

Add the following line to your pubspec.yaml file:

```yaml
dependencies:
  custom_tooltip_google_maps: ^0.0.1
```

## Usage

First, import the package:

```dart
import 'package:custom_tooltip_google_maps/custom_tooltip_google_maps.dart';
```

Then, create a GoogleMap widget and wrap it with a CustomTooltipController widget. 
Pass the CustomTooltipController instance to the CustomTooltip widget.

```dart
CustomTooltipController _tooltipController = CustomTooltipController();

GoogleMap(
  mapType: MapType.normal,
  markers: _markers,
  onMapCreated: (GoogleMapController controller) {
    _controller.complete(controller);
    _tooltipController.googleMapController = controller;
  },
  onCameraMove: (cameraPosition) {
    _tootlipController.onCameraMoved?.call();
  },
  markers: <Marker>{
    for (final place in _places.entries)
      Marker(
        markerId: MarkerId(place.key),
        position: place.value,
        onTap: () {
          _tootlipController.onMarkerTapped?.call(place.value);
        },
      ),
    },
),

CustomTooltip(
controller: _tooltipController,
title: 'Marker Title',
body: Text('Marker description'),
tooltipColor: Colors.blue,
width: 200,
height: 50,
offset: 50,
),
```

## Customization

The following properties of `CustomTooltip` can be customized:

`title`: The title of the tooltip.
`body`: The body of the tooltip.
`tooltipColor`: The color of the tooltip.
`titleStyle`: The style of the title text.
`closeIcon`: The close icon of the tooltip.
`width`: The width of the tooltip.
`height`: The height of the tooltip.
`offset`: The distance from the marker.

## Contributing
Contributions are welcome! If you have any issues or feature requests, please open a new issue on GitHub. 
If you would like to contribute code, please fork the repository and submit a pull request.
