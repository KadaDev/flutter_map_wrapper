import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_wrapper/animate_in_from_bottom.dart';
import 'package:flutter_map_wrapper/localizations.dart';
import 'package:flutter_map_wrapper/map_markers.dart';
import 'package:flutter_map_wrapper/map_polygons.dart';
import 'package:flutter_map_wrapper/map_style_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'models/map_point.dart';
import 'models/map_style.dart';

class ZoomSettings {
  const ZoomSettings({
    this.initialZoom = 5,
    this.maxZoom = 20,
    this.minZoom = 1,
    this.constrainZoom = false,
  }) : assert(minZoom < maxZoom);
  final double initialZoom;
  final double maxZoom;
  final double minZoom;
  final bool constrainZoom;

  setZoom() {
    if (constrainZoom) {
      /*
      minZoom = math.max(
        controller.zoom - 2,
        widget.zoom.minZoom,
      );
      maxZoom = math.min(
        controller.zoom + 2,
        widget.zoom.maxZoom,
      );
      */
    }
  }
}

class UserLocationOptions {
  UserLocationOptions({
    this.buttonZoomLevel,
    this.initialZoomLevel,
    this.followOnLocationUpdate = FollowOnLocationUpdate.once,
  });
  final double? buttonZoomLevel;
  final double? initialZoomLevel;
  final FollowOnLocationUpdate followOnLocationUpdate;
}

class MapWidget<PointDataType extends Object?, PolygonDataType extends Object?>
    extends StatefulWidget {
  MapWidget({
    super.key,
    required this.mapStyles,
    this.zoom = const ZoomSettings(),
    this.center,
    this.onSetZoom,
    this.markers,
    this.polygons,
    this.detailsPanelBuilder,
    this.userLocationOptions,
    this.localizations = const FlutterMapWrapperLocalizations(),
  }) : assert(mapStyles.isNotEmpty);

  final FlutterMapWrapperLocalizations localizations;

  final List<MapStyle> mapStyles;

  final ZoomSettings zoom;
  final UserLocationOptions? userLocationOptions;

  final MapMarkers<PointDataType>? markers;
  final MapPolygons<PolygonDataType>? polygons;

  final LatLng? center;

  final void Function(CenterZoom)? onSetZoom;

  final Widget Function(BuildContext, MapPoint<PointDataType>)?
      detailsPanelBuilder;
  @override
  MapWidgetState<PointDataType, PolygonDataType> createState() =>
      MapWidgetState<PointDataType, PolygonDataType>();
}

class MapWidgetState<PointDataType, PolygonDataType>
    extends State<MapWidget<PointDataType, PolygonDataType>> {
  final ValueNotifier<int> mapStyleIndex = ValueNotifier(0);

  MapStyle get selectedStyle => widget.mapStyles[mapStyleIndex.value];

  ValueNotifier<MapPoint<PointDataType>?> selectedPoint = ValueNotifier(null);

  FollowOnLocationUpdate _followOnLocationUpdate = FollowOnLocationUpdate.never;

  late final StreamController<double?> _followCurrentLocationStreamController;
  late final Stream<double?> stream;

  late final Stream<LocationMarkerPosition?> positionStream =
      const LocationMarkerDataStreamFactory()
          .fromGeolocatorPositionStream()
          .asBroadcastStream();

  late final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    mapStyleIndex.addListener(() {
      setState(() {});
    });

    _followCurrentLocationStreamController = StreamController<double?>();

    final userLocationOptions = widget.userLocationOptions;
    if (userLocationOptions != null) {
      _followOnLocationUpdate = userLocationOptions.followOnLocationUpdate;

      if (_followOnLocationUpdate == FollowOnLocationUpdate.always ||
          _followOnLocationUpdate == FollowOnLocationUpdate.once) {
        positionStream.first.then((value) {
          if (!_followCurrentLocationStreamController.isClosed) {
            _followCurrentLocationStreamController
                .add(userLocationOptions.initialZoomLevel);
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(
      covariant MapWidget<PointDataType, PolygonDataType> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userLocationOptions != oldWidget.userLocationOptions &&
        oldWidget.userLocationOptions == null) {
      _followOnLocationUpdate =
          widget.userLocationOptions!.followOnLocationUpdate;
    }
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  void _onPositionChanged(MapPosition position, bool hasGesture) {
    // Stop centering the location marker on the map if user interacted with the map.
    if (hasGesture && _followOnLocationUpdate != FollowOnLocationUpdate.never) {
      setState(() {
        _followOnLocationUpdate = FollowOnLocationUpdate.never;
      });
    }
  }

  void _onMapCreated() async {
    widget.onSetZoom?.call(
      CenterZoom(
        center: _mapController.center,
        zoom: _mapController.zoom,
      ),
    );
  }

  void _onUserLocationButtonPressed() {
    // TODO: if we don't have permissions, show permissions snackbar

    // Automatically center the location marker on the map when
    // location updated until user interact with the map.
    if (_followOnLocationUpdate != FollowOnLocationUpdate.always) {
      setState(() {
        _followOnLocationUpdate = FollowOnLocationUpdate.always;
      });
    }
    // Center the location marker on the map and zoom the map
    if (widget.userLocationOptions != null) {
      _followCurrentLocationStreamController.add(
        widget.userLocationOptions!.buttonZoomLevel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialZoom = widget.zoom.initialZoom;
    debugPrint('[flutter_map_wrapper]: initialZoom is $initialZoom');

    final LatLngBounds? bounds;
    if (widget.center == null) {
      final markerBounds = widget.markers?.bounds;
      final polygonBounds = widget.polygons?.bounds;

      if (markerBounds != null && polygonBounds != null) {
        bounds = markerBounds..extendBounds(polygonBounds);
      } else {
        bounds = markerBounds ?? polygonBounds;
      }
    } else {
      bounds = null;
    }
    final mapOptions = MapOptions(
      onMapReady: _onMapCreated,
      interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
      center: widget.center,
      zoom: initialZoom,
      minZoom: widget.zoom.minZoom,
      maxZoom: widget.zoom.maxZoom,
      bounds: bounds,
      nePanBoundary: bounds?.northEast,
      swPanBoundary: bounds?.southWest,
      slideOnBoundaries: bounds != null,
      onTap: (pos, latLng) {
        selectedPoint.value = null;
      },
      onPositionChanged: _onPositionChanged,
    );

    final userLocationOptions = widget.userLocationOptions;

    return FlutterMapWrapperLocalizationsInherited(
      localizations: widget.localizations,
      child: RepaintBoundary(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: mapOptions,
              children: [
                selectedStyle.tileLayer(context),
                if (widget.userLocationOptions != null)
                  CurrentLocationLayer(
                    followCurrentLocationStream:
                        _followCurrentLocationStreamController.stream,
                    followOnLocationUpdate: _followOnLocationUpdate,
                    positionStream: positionStream,
                  ),
                if (widget.polygons != null) widget.polygons!,
                if (widget.markers != null) widget.markers!,
              ],
            ),
            if (widget.mapStyles.length > 1)
              _MapStyleButton(
                mapStyles: widget.mapStyles,
                mapStyleIndex: mapStyleIndex,
              ),
            if (userLocationOptions != null)
              ValueListenableBuilder(
                valueListenable: selectedPoint,
                builder: (context, point, child) {
                  if (point != null && widget.detailsPanelBuilder != null) {
                    return const SizedBox();
                  }
                  return child!;
                },
                child: _MapLocationButton(
                  followOnLocationUpdate: _followOnLocationUpdate,
                  onPressed: _onUserLocationButtonPressed,
                ),
              ),
            ValueListenableBuilder(
              valueListenable: selectedPoint,
              builder: (context, MapPoint<PointDataType>? point, child) {
                Widget? content;
                if (point != null && widget.detailsPanelBuilder != null) {
                  content = widget.detailsPanelBuilder!(context, point);
                }
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimateInFromBottom(
                    child: content,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MapLocationButton extends StatelessWidget {
  const _MapLocationButton({
    required this.onPressed,
    required this.followOnLocationUpdate,
  });
  final VoidCallback onPressed;

  final FollowOnLocationUpdate followOnLocationUpdate;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Padding(
        padding: MediaQuery.of(context).padding.add(
              const EdgeInsets.all(16.0),
            ),
        child: FloatingActionButton(
          heroTag: null,
          onPressed: onPressed,
          child: Icon(
            _getUserLocationFabIcon(context),
          ),
        ),
      ),
    );
  }

  IconData _getUserLocationFabIcon(BuildContext context) {
    // TODO: check for user geolocation permissions, if no permissions use gps_off
    return followOnLocationUpdate == FollowOnLocationUpdate.always
        ? Icons.gps_fixed
        : Icons.gps_not_fixed;
  }
}

class _MapStyleButton extends StatelessWidget {
  const _MapStyleButton({
    required this.mapStyles,
    required this.mapStyleIndex,
  });

  final List<MapStyle> mapStyles;
  final ValueNotifier<int> mapStyleIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: Padding(
        padding: MediaQuery.of(context).padding.add(
              const EdgeInsets.all(16.0),
            ),
        child: FloatingActionButton.small(
          heroTag: null,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          child: const Icon(Icons.layers),
          onPressed: () {
            final localizations = context.localizations;
            showModalBottomSheet(
              context: context,
              enableDrag: true,
              isScrollControlled: true,
              builder: (context) {
                return FlutterMapWrapperLocalizationsInherited(
                  localizations: localizations,
                  child: MapStylePicker(
                    mapStyles: mapStyles,
                    selectedIndex: mapStyleIndex,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
