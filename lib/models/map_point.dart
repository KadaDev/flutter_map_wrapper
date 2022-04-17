import 'package:latlong2/latlong.dart';

class MapPoint<T> extends LatLng {
  MapPoint({
    required LatLng point,
    required this.data,
  }) : super(point.latitude, point.longitude);

  final T data;
}
