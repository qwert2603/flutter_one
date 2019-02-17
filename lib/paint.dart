import 'package:flutter/material.dart';

class Signature extends StatefulWidget {
  SignatureState createState() => SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];
  List<Offset> _circles = <Offset>[];

  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        setState(() {
          RenderBox renderObject = context.findRenderObject();
          _circles = List.from(_circles)
            ..add(renderObject.globalToLocal(details.globalPosition));
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
          _points = List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child: CustomPaint(
          painter: SignaturePainter(_points, _circles), size: Size.infinite),
    );
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points, this.circles);

  final List<Offset> points;
  final List<Offset> circles;

  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }

    final circlesPaint = Paint()
      ..color = Colors.lightGreenAccent
      ..style = PaintingStyle.fill;

    circles.forEach((circle) {
      canvas.drawCircle(circle, 19, circlesPaint);
    });
  }

  bool shouldRepaint(SignaturePainter other) =>
      other.points != points || other.circles != circles;
}
