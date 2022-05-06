import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_wrapper/localizations.dart';
import 'package:flutter_map_wrapper/models/map_style.dart';
import 'package:flutter_map_wrapper/util/inkwell_wrapper.dart';

class MapStylePicker extends StatelessWidget {
  const MapStylePicker({
    Key? key,
    required this.mapStyles,
    required this.selectedIndex,
  }) : super(key: key);

  final List<MapStyle> mapStyles;
  final ValueNotifier<int> selectedIndex;

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.localizations.chooseMapType,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );

    final body = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ValueListenableBuilder<int>(
          valueListenable: selectedIndex,
          builder: (context, _, child) {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (mapStyles.length <= 4) ? 2 : 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1,
              ),
              itemCount: mapStyles.length,
              itemBuilder: (context, index) {
                final style = mapStyles[index];
                return _MapStylePreview(
                  mapStyle: style,
                  selected: index == selectedIndex.value,
                  onSelected: () {
                    selectedIndex.value = index;
                  },
                );
              },
            );
          }),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        header,
        body,
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class _MapStylePreview extends StatelessWidget {
  const _MapStylePreview({
    Key? key,
    required this.mapStyle,
    this.selected = false,
    required this.onSelected,
  }) : super(key: key);

  final MapStyle mapStyle;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final previewImageUrl = _template(
      mapStyle.urlTemplate,
      {
        if (mapStyle.subdomains != null) 's': mapStyle.subdomains!.first,
        'z': '16',
        'x': '35613',
        'y': '19593',
      },
    );

    // TODO: read from theme or something
    final BorderRadius borderRadius = BorderRadius.circular(8.0);

    return InkwellWrapper(
      color: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          style: BorderStyle.solid,
          width: 4.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: previewImageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(mapStyle.title),
          ),
        ],
      ),
      inkWell: InkWell(
        onTap: onSelected,
      ),
    );
  }
}

/// Copied from flutter_map
final _templateRe = RegExp(r'\{ *([\w_-]+) *\}');

/// Replaces the templating placeholders with the provided data map.
///
/// Example input: https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png
///
/// Throws an [Exception] if any placeholder remains unresolved.
String _template(String str, Map<String, String> data) {
  return str.replaceAllMapped(_templateRe, (Match match) {
    var firstMatch = match.group(1);
    if (firstMatch == null) {
      throw Exception('incorrect URL template: $str');
    }
    var value = data[firstMatch];
    if (value == null) {
      throw Exception('No value provided for variable ${match.group(1)}');
    } else {
      return value;
    }
  });
}