import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_wrapper/models/map_point.dart';

Marker createTextMarker<T>({
  required BuildContext context,
  required MapPoint<T> point,
  required String text,
  VoidCallback? onTap,
  Color? color,
}) {
  final ThemeData theme = Theme.of(context);

  final Color textColor = color ?? theme.textTheme.titleMedium!.color!;

  final style = theme.textTheme.titleMedium!.copyWith(
    color: textColor,
  );

  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    textAlign: TextAlign.center,
    maxLines: 3,
    textDirection: Directionality.of(context),
  )..layout(maxWidth: 100);
  final size = painter.size;

  const padding = EdgeInsets.all(8);
  return Marker(
    point: point,
    height: (size.height * 2) + padding.bottom + padding.top,
    width: (size.width * 2) + padding.left + padding.right,
    anchorPos: AnchorPos.align(AnchorAlign.center),
    builder: (context) {
      return Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: textColor.contrastColor,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
        ),
      );
    },
  );
}

extension ContrastColor on Color {
  Color get contrastColor {
    final brightness = ThemeData.estimateBrightnessForColor(this);
    switch (brightness) {
      case Brightness.dark:
        return Colors.white60;
      case Brightness.light:
        return Colors.black54;
    }
  }
}
