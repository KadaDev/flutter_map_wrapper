import 'package:flutter/widgets.dart';

class AnimateInFromBottom extends StatefulWidget {
  const AnimateInFromBottom({
    super.key,
    required this.child,
  });

  final Widget? child;

  @override
  State<AnimateInFromBottom> createState() => _AnimateInFromBottomState();
}

class _AnimateInFromBottomState extends State<AnimateInFromBottom>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  Widget? previousWidget;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    offset = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(controller);
    if (widget.child != null) controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimateInFromBottom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child) {
      if (oldWidget.child != null) {
        previousWidget = oldWidget.child;
      }
      if (widget.child == null) {
        controller.reverse();
      } else {
        controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offset,
      child: widget.child ?? previousWidget,
    );
  }
}
