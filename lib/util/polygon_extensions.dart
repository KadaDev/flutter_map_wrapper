import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

extension PolygonExtensions on Polygon {
  LatLng get center => LatLngBounds.fromPoints(points).center;
}
