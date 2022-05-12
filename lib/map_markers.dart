import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_wrapper/map_cluster_marker.dart';
import 'package:flutter_map_wrapper/map_widget.dart';
import 'package:flutter_map_wrapper/models/map_point.dart';

typedef ClusterMarkerBuilder<T extends MapPoint> = Widget Function(
  BuildContext,
  List<T>,
);

typedef MarkerBuilder<T extends MapPoint> = Widget Function(BuildContext, T);

class MapMarkers<T> extends StatelessWidget {
  const MapMarkers({
    super.key,
    required this.markers,
    required this.markerBuilder,
    this.clusterMarkerBuilder,
    this.onMarkerTap,
    this.markerSize = 48.0,
    this.maxClusterRadius = 96,
  });

  final List<MapPoint<T>> markers;
  final double markerSize;
  final int maxClusterRadius;

  final MarkerBuilder<MapPoint<T>> markerBuilder;
  final ClusterMarkerBuilder<MapPoint<T>>? clusterMarkerBuilder;
  final void Function(MapPoint<T>)? onMarkerTap;

  LatLngBounds? get bounds => markers.isEmpty
      ? null
      : LatLngBounds.fromPoints(
          markers,
        );

  @override
  Widget build(BuildContext context) {
    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        maxClusterRadius: maxClusterRadius,
        size: const Size(48, 48),
        fitBoundsOptions: const FitBoundsOptions(
          // How much padding to use when zooming to a tapped cluster
          padding: EdgeInsets.all(24),
        ),
        markers: markers.map((e) => _markerBuilder(e)).toList(),
        showPolygon: false,
        builder: (context, markers) {
          if (clusterMarkerBuilder != null) {
            return clusterMarkerBuilder!(
              context,
              markers.map((m) => m.point).cast<MapPoint<T>>().toList(),
            );
          }
          return MapClusterMarker(
            child: Text('${markers.length}'),
          );
        },
        zoomToBoundsOnClick: true,
        centerMarkerOnClick: true,
        onClusterTap: (clusterNode) {
          context
              .findAncestorStateOfType<MapWidgetState>()!
              .selectedPoint
              .value = null;
        },
        onMarkerTap: (marker) {
          final MapPoint<T> point = marker.point as MapPoint<T>;
          context
              .findAncestorStateOfType<MapWidgetState>()!
              .selectedPoint
              .value = point;
          onMarkerTap?.call(point);
        },
      ),
    );
  }

  Marker _markerBuilder(MapPoint<T> mp) {
    return Marker(
      point: mp,
      anchorPos: AnchorPos.align(AnchorAlign.top),
      height: markerSize,
      width: markerSize,
      builder: (context) {
        return markerBuilder(context, mp);
      },
    );
  }
}
