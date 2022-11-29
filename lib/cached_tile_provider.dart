import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';

class CachedTileProvider extends TileProvider {
  @override
  ImageProvider getImage(Coords<num> coords, TileLayer options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
      // Now you can set options that determine how the image gets cached via
      // whichever plugin you use.
    );
  }
}
