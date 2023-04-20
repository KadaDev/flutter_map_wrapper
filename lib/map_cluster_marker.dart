import 'package:flutter/material.dart';

class MapClusterMarker extends StatelessWidget {
  const MapClusterMarker({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary.withOpacity(0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary,
          ),
          child: Center(
            child: DefaultTextStyle(
              style: theme.primaryTextTheme.bodyMedium!,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
