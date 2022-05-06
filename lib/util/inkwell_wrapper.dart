import 'package:flutter/material.dart';

class InkwellWrapper extends StatelessWidget {
  const InkwellWrapper({
    Key? key,
    required this.inkWell,
    required this.child,
    this.shape,
    this.color,
  }) : super(key: key);

  final Widget inkWell;
  final Widget child;
  final Color? color;
  final RoundedRectangleBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Material(
            clipBehavior: shape != null ? Clip.antiAlias : Clip.none,
            color: color,
            shape: shape,
            child: child,
          ),
        ),
        Positioned.fill(
          child: Material(
            clipBehavior: shape != null ? Clip.antiAlias : Clip.none,
            color: Colors.transparent,
            shape: shape?.copyWith(side: null),
            child: inkWell,
          ),
        ),
      ],
    );
  }
}
