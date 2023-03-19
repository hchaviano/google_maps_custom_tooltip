library google_maps_custom_tooltip;

import 'package:flutter/material.dart';
import 'package:google_maps_custom_tooltip/custom_tooltip_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// A custom tooltip widget that appears above the [Marker] in [GoogleMap]
/// with a title and an optional body.
class CustomTooltip extends StatefulWidget {
  /// Creates a custom tooltip widget.
  ///
  /// The [controller], [title], and [width] are required arguments.
  const CustomTooltip({
    super.key,
    required this.controller,
    required this.title,
    this.tooltipColor = Colors.blue,
    this.titleStyle = const TextStyle(color: Colors.white),
    this.closeIcon = const Icon(
      Icons.clear,
      color: Colors.white,
    ),
    this.body,
    this.offset = 50,
    this.height = 50,
    this.width = 200,
  });

  /// The controller that manages [CustomTooltip] and the [GoogleMap].
  final CustomTooltipController controller;

  /// The title of the tooltip.
  final String title;

  /// The color of the tooltip.
  final Color tooltipColor;

  /// The style of the title.
  final TextStyle titleStyle;

  /// The close icon of the tooltip.
  final Widget closeIcon;

  /// The body of the tooltip.
  final Widget? body;

  /// The distance from the marker.
  final double offset;

  /// The height of the tooltip.
  final double height;

  /// The width of the tooltip.
  final double width;

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  late LatLng _latLng;
  bool _isVisible = false;
  double _leftMargin = 0;
  double _topMargin = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.onMarkerTapped = _onMarkerTapped;
    widget.controller.onCameraMoved = _onCameraMoved;
  }

  /// Updates the position of the tooltip on the screen when a marker is tapped
  /// or the camera is moved.
  Future<void> _updateTooltipPosition() async {
    try {
      final screenCoordinate = await widget.controller.googleMapController
          ?.getScreenCoordinate(_latLng);

      final tooltipPosition = _getTooltipPosition(
        width: widget.width,
        height: widget.height,
        offset: widget.offset,
        screenCoordinate: screenCoordinate,
      );

      final left = tooltipPosition.first;
      final top = tooltipPosition.last;

      setState(() {
        _isVisible = true;
        _leftMargin = left;
        _topMargin = top;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Sets the [_latLng] to the tapped marker and updates the tooltip position.
  void _onMarkerTapped(LatLng latLng) {
    _latLng = latLng;
    _updateTooltipPosition();
  }

  /// Updates the tooltip position when the camera is moved and the tooltip is
  /// currently visible.
  void _onCameraMoved() {
    if (_isVisible) {
      _updateTooltipPosition();
    }
  }

  /// Hides the tooltip.
  void _hideTooltip() {
    setState(() {
      _isVisible = false;
    });
  }

  ///Returns the left and top margin values of the tooltip widget
  ///relative to the screen.
  /// [width] The width of the tooltip widget.
  /// [height] The height of the tooltip widget.
  /// [offset] The vertical distance between the marker and the tooltip.
  /// [screenCoordinate] The screen coordinate of the marker on the map.
  List<double> _getTooltipPosition({
    required double width,
    required double height,
    required double offset,
    ScreenCoordinate? screenCoordinate,
  }) {
    if (screenCoordinate == null) {
      return [];
    }

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final left = screenCoordinate.x.toDouble() / devicePixelRatio - (width / 2);
    final top =
        screenCoordinate.y.toDouble() / devicePixelRatio - (offset + height);

    return [left, top];
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Positioned(
            left: _leftMargin,
            top: _topMargin,
            child: _Tooltip(
              width: widget.width,
              height: widget.height,
              title: widget.title,
              titleStyle: widget.titleStyle,
              onCloseTap: _hideTooltip,
              tooltipColor: widget.tooltipColor,
              closeIcon: widget.closeIcon,
              body: widget.body,
            ),
          )
        : const SizedBox();
  }
}

class _Tooltip extends StatelessWidget {
  const _Tooltip({
    required this.width,
    required this.height,
    required this.title,
    required this.titleStyle,
    required this.onCloseTap,
    required this.tooltipColor,
    required this.closeIcon,
    this.body,
  });

  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final Color tooltipColor;
  final Widget closeIcon;
  final VoidCallback onCloseTap;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: Material(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: tooltipColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        title,
                        style: titleStyle,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        onPressed: onCloseTap,
                        icon: closeIcon,
                      ),
                    )
                  ],
                ),
              ),
              if (body != null) body!,
            ],
          ),
        ),
      ),
    );
  }
}
