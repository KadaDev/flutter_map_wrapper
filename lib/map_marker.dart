import 'package:flutter/widgets.dart';

class MapMarker extends StatelessWidget {
  const MapMarker({
    Key? key,
    required this.color,
    this.child,
  }) : super(key: key);

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 100 / 160, // Original size of the vector
        child: CustomPaint(
          painter: MarkerPainter(color: color),
          child: FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.6,
            widthFactor: 1,
            child: FittedBox(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class MarkerPainter extends CustomPainter {
  const MarkerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = color;

    final path = _getPath(size);

    canvas.drawShadow(path, const Color(0xFF000000), 4, false);

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant MarkerPainter oldDelegate) {
    return oldDelegate.color != color;
  }

  Path _getPath(Size size) {
    final Path path = Path();

    path.lineTo(
      size.width * 1.2,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 1.2,
      size.height * 0.67,
      size.width * 0.9,
      size.height * 0.57,
      size.width * 0.74,
      size.height * 1.07,
    );
    path.cubicTo(
      size.width * 0.73,
      size.height * 1.09,
      size.width * 0.67,
      size.height * 1.09,
      size.width * 0.66,
      size.height * 1.07,
    );
    path.cubicTo(
      size.width / 2,
      size.height * 0.57,
      size.width / 5,
      size.height * 0.67,
      size.width / 5,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width / 5,
      size.height * 0.24,
      size.width * 0.4,
      size.height * 0.09,
      size.width * 0.7,
      size.height * 0.09,
    );
    path.cubicTo(
      size.width,
      size.height * 0.09,
      size.width * 1.2,
      size.height * 0.24,
      size.width * 1.2,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 1.2,
      size.height * 0.4,
      size.width * 1.2,
      size.height * 0.4,
      size.width * 1.2,
      size.height * 0.4,
    );

    return path.shift(Offset(size.width * -0.2, size.height * -0.1));
  }
}
