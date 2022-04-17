import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_wrapper/models/map_polygon.dart';

class PolygonWithExtra<T> extends Polygon {
  PolygonWithExtra({
    required this.extra,
    required super.points,
    super.borderColor,
    super.borderStrokeWidth,
    super.color,
    super.disableHolesBorder,
    super.holePointsList,
    super.isDotted,
  });

  final T extra;
}

class MapPolygons<T> extends StatelessWidget {
  const MapPolygons({
    Key? key,
    required this.polygons,
    this.onLabelTap,
    this.labelMarkerBuilder,
  }) : super(key: key);

  final List<MapPolygon<T>> polygons;
  final void Function(MapPolygon<T>)? onLabelTap;
  final Marker Function(BuildContext, MapPolygon<T>)? labelMarkerBuilder;

  LatLngBounds? get bounds => polygons.isEmpty
      ? null
      : LatLngBounds.fromPoints(
          polygons.expand((m) => m.points).toList(),
        );

  @override
  Widget build(BuildContext context) {
    late final List<Marker>? polygonMarkers;

    if (labelMarkerBuilder != null) {
      polygonMarkers =
          polygons.map((p) => labelMarkerBuilder!(context, p)).toList();
    } else {
      polygonMarkers = null;
    }

    return GroupLayerWidget(
      options: GroupLayerOptions(group: [
        PolygonLayerOptions(
          polygons: polygons,
        ),
        if (polygonMarkers != null) MarkerLayerOptions(markers: polygonMarkers),
      ]),
    );
  }
}
