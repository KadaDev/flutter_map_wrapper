import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_wrapper/cached_tile_provider.dart';

class MapStyle {
  const MapStyle({
    required this.title,
    required this.urlTemplate,
    this.maxNativeZoom,
    this.subdomains,
    this.maxZoom,
    this.minZoom,
  });

  final String title;
  final String urlTemplate;
  final double? maxNativeZoom;
  final double? minZoom;
  final double? maxZoom;
  final List<String>? subdomains;

  TileLayerOptions tileLayerOptions(BuildContext context) {
    return TileLayerOptions(
      urlTemplate: urlTemplate,
      subdomains: subdomains ?? const <String>[],
      maxNativeZoom: maxNativeZoom,
      retinaMode: MediaQuery.of(context).devicePixelRatio >= 2,
      tileProvider: const CachedTileProvider(),
      maxZoom: maxZoom ?? 18,
      minZoom: minZoom ?? 0,
    );
  }
}
