import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_wrapper/flutter_map_wrapper.dart';
import 'package:flutter_map_wrapper/util/hex_to_color.dart';

void main() {
  runApp(const MyApp());
}

class PointData {
  PointData({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

class PolygonData {
  PolygonData({
    required this.title,
    required this.description,
    required this.color,
  });

  final String title;
  final String description;
  final String color;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData.from(
      colorScheme: const ColorScheme.light(),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const String ifiskeMap =
      'https://maps.ifiske.se/topo/wmts/sweden/GLOBAL_WEBMERCATOR';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getPermission();
  }

  final List<MapStyle> mapStyles = [
    const MapStyle(
      title: 'Terrain map',
      urlTemplate: '${MyHomePage.ifiskeMap}/{z}/{x}/{y}.png',
      maxZoom: 20,
      maxNativeZoom: 15,
    ),
    const MapStyle(
      title: 'Open Street Map',
      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      subdomains: ['a', 'b', 'c'],
    ),
  ];

  final List<MapPoint<PointData>> points = [
    MapPoint(
      point: LatLng(62.4, 13.5),
      data: PointData(
        title: "Test marker 1",
        description: "Description 1",
      ),
    ),
    MapPoint(
      point: LatLng(63.1, 16.2),
      data: PointData(
        title: "Test marker 2",
        description: "Description 2",
      ),
    ),
  ];

  final List<MapPolygon<PolygonData>> polygons = [
    MapPolygon.fromString(
      baseColor: hexToColor("#abc123"),
      polygonString: "[62,15],[63,15],[63,16],[62,16]",
      data: PolygonData(
        title: "Test Polygon Test Polygon Test Polygon Test Polygon",
        description: "Description",
        color: "#abc123",
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Demo'),
      ),
      body: MapWidget<PointData, PolygonData>(
        mapStyles: mapStyles,
        center: LatLng(62.0, 15.0),
        userLocationOptions: UserLocationOptions(
          buttonZoomLevel: 15,
          centerOnLocationUpdate: CenterOnLocationUpdate.once,
          initialZoomLevel: 12,
        ),
        markers: MapMarkers(
          markers: points,
          markerBuilder: (context, point) {
            return MapMarker(
              color: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.star,
                color: Colors.amber,
              ),
            );
          },
          clusterMarkerBuilder: (context, markers) {
            return MapClusterMarker(
              child: Text('${markers.length}'),
            );
          },
        ),
        zoom: const ZoomSettings(
          constrainZoom: false,
        ),
        polygons: MapPolygons(
          polygons: polygons,
          labelMarkerBuilder: (context, polygon) {
            return createTextMarker(
              context: context,
              point: MapPoint<PolygonData>(
                point: polygon.center,
                data: polygon.data,
              ),
              text: polygon.data.title,
              color: hexToColor(polygon.data.color),
              onTap: () {
                print('Tapped ${polygon.data.title}');
              },
            );
          },
        ),
        detailsPanelBuilder: (context, MapPoint<PointData> point) {
          return DetailsPanel(
            key: ValueKey(point.data),
            title: Text(point.data.title),
            leading: const Icon(Icons.star),
            content: (point.data.description.isNotEmpty)
                ? Text(
                    point.data.description,
                  )
                : null,
          );
        },
      ),
    );
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<void> _getPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
}
