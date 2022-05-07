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
    this.supportsNativeRetinaMode = false,
  });

  final String title;
  final String urlTemplate;
  final double? maxNativeZoom;
  final double? minZoom;
  final double? maxZoom;
  final List<String>? subdomains;
  final bool supportsNativeRetinaMode;

  TileLayerOptions tileLayerOptions(BuildContext context) {
    final useRetinaMode = MediaQuery.of(context).devicePixelRatio >= 2;
    return TileLayerOptions(
      urlTemplate: urlTemplate,
      subdomains: subdomains ?? const <String>[],
      maxNativeZoom: maxNativeZoom,
      retinaMode: supportsNativeRetinaMode ? false : useRetinaMode,
      tileProvider: const CachedTileProvider(),
      additionalOptions: {
        'retinaMode': supportsNativeRetinaMode && useRetinaMode ? '@2x' : ''
      },
      maxZoom: maxZoom ?? 18,
      minZoom: minZoom ?? 0,
    );
  }
}
