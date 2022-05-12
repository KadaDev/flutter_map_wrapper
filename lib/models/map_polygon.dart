import 'dart:convert';
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

List<LatLng> _getPoints(String polygonString) {
  final List<dynamic> list = jsonDecode('[$polygonString]');
  return list
      .map<LatLng>(
        (dynamic p) => LatLng(p[0].toDouble(), p[1].toDouble()),
      )
      .toList();
}

class MapPolygon<T> extends Polygon {
  static const int colorAlpha = 0x20;
  static const int borderAlpha = 0xD0;
  static const double defaultBorderStrokeWidth = 3;

  MapPolygon({
    required this.baseColor,
    required this.data,
    required super.points,
    super.borderStrokeWidth = defaultBorderStrokeWidth,
    super.holePointsList,
    super.disableHolesBorder,
    super.isDotted,
  }) : super(
          color: baseColor.withAlpha(colorAlpha),
          borderColor: baseColor.withAlpha(borderAlpha),
        );

  MapPolygon.fromString({
    required String polygonString,
    required this.baseColor,
    required this.data,
    super.borderStrokeWidth = defaultBorderStrokeWidth,
    super.holePointsList,
    super.disableHolesBorder,
    super.isDotted,
  }) : super(
          points: _getPoints(polygonString),
          color: baseColor.withAlpha(colorAlpha),
          borderColor: baseColor.withAlpha(borderAlpha),
        );

  final T data;
  final Color baseColor;

  LatLng get center => LatLngBounds.fromPoints(points).center;
}
