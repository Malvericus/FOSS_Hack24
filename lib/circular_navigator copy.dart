import 'package:flutter/material.dart';
import 'dart:math';

class CircularSelector extends StatefulWidget {
  const CircularSelector({
    super.key,
    required this.children,
    required this.childSize,
    required this.radiusDividend,
    required this.customOffset,
    this.circleBackgroundColor = Colors.transparent,
    this.dividerColor = Colors.black,
    this.dividerWidth = 2.0,
  });

  final double radiusDividend;
  final List<CircularSelectorItem> children;
  final double childSize;
  final Offset customOffset;
  final Color circleBackgroundColor;
  final Color dividerColor;
  final double dividerWidth;

  @override
  State<CircularSelector> createState() => _CircularSelectorState();
}

class _CircularSelectorState extends State<CircularSelector>
    with SingleTickerProviderStateMixin {
  late double rotation;
  late AnimationController _controller;
  late Animation<double> _animation;
  late double startRotation;
  double totalRotation = 0;

  @override
  void initState() {
    super.initState();
    rotation = 0.0;
    startRotation = 0.0;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          rotation = _animation.value;
        });
      });
  }

  Function(DragStartDetails) _onPanStart(double xOrigin, double yOrigin) {
    return (DragStartDetails details) {
      if (_controller.isAnimating) {
        _controller.stop();
      }
      final dx = details.localPosition.dx;
      final dy = details.localPosition.dy;

      startRotation = calculateGestureAngle(dx, dy, xOrigin, yOrigin);
      totalRotation = 0;
    };
  }

  Function(DragUpdateDetails) _onPanUpdate(double xOrigin, double yOrigin) {
    return (DragUpdateDetails details) {
      final dx = details.localPosition.dx;
      final dy = details.localPosition.dy;

      final angle = calculateGestureAngle(dx, dy, xOrigin, yOrigin);

      final angleDiff = angle - startRotation;

      setState(() {
        rotation += (angleDiff * pi / 180);
        startRotation = angle;
      });

      totalRotation += angleDiff;
    };
  }

  void _onPanEnd(DragEndDetails details) {
    final anglePerChild = 2 * pi / widget.children.length;
    double closestRotation = (rotation / anglePerChild).round() * anglePerChild;

    _controller.duration = const Duration(milliseconds: 100);

    // If the rotation is close to a child, snap to that child
    _animation = Tween<double>(begin: rotation, end: closestRotation).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          rotation = _animation.value;
        });
      });

    _controller.forward(from: 0);
  }

  double calculateGestureAngle(
      double dx, double dy, double xOrigin, double yOrigin) {
    double angle = atan2(dy - yOrigin, dx - xOrigin) * 180 / pi;
    angle = angle < 0 ? 360 + angle : angle;
    angle = (angle + 90) % 360; // Adjusting the origin to 12 o'clock
    return angle;
  }

  @override
  Widget build(BuildContext context) {
    final parentWidth = MediaQuery.of(context).size.width;
    final parentHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    final xOrigin =
        (min(parentWidth, parentHeight) / widget.radiusDividend * 2) / 2;
    final yOrigin =
        (min(parentWidth, parentHeight) / widget.radiusDividend * 2) / 2;

    Point getPosition(
        int index, double childSize, double xOrigin, double yOrigin) {
      final double radius =
          min(parentWidth, parentHeight) / widget.radiusDividend;
      final angle = 2 * pi * index / widget.children.length;
      final dx = xOrigin + radius * cos(-(angle - pi / 2)) + childSize / 2;
      final dy = yOrigin + radius * sin(-(angle - pi / 2)) + childSize / 2;
      return Point(dx, dy);
    }

    List<Widget> positionedChildren = [];

    // // Add divider lines
    // for (int i = 0; i < widget.children.length; i++) {
    //   final startAngle = 2 * pi * i / widget.children.length;
    //   final endAngle = 2 * pi * (i + 1) / widget.children.length;

    //   positionedChildren.add(
    //     CustomPaint(
    //       painter: DividerPainter(
    //         startAngle: startAngle,
    //         endAngle: endAngle,
    //         radius: min(parentWidth, parentHeight) / widget.radiusDividend,
    //         color: widget.dividerColor,
    //         strokeWidth: widget.dividerWidth,
    //       ),
    //       size: Size(
    //         min(parentWidth, parentHeight) / widget.radiusDividend * 2,
    //         min(parentWidth, parentHeight) / widget.radiusDividend * 2,
    //       ),
    //     ),
    //   );
    // }

    // Add child widgets
    for (int i = 0; i < widget.children.length; i++) {
      final position = getPosition(i, widget.childSize, xOrigin, yOrigin);
      final child = widget.children[i].child;
      final positionedChild = Positioned(
        left: position.x.toDouble(),
        bottom: position.y.toDouble(),
        child: Container(
          width: widget.childSize,
          height: widget.childSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Center(child: child),
        ),
      );
      positionedChildren.add(positionedChild);
    }

    return SizedBox(
        width: min(parentWidth, parentHeight) / widget.radiusDividend * 2 +
            widget.childSize * 2,
        height: min(parentWidth, parentHeight) / widget.radiusDividend * 2 +
            widget.childSize * 2,
        // child: Container(
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: widget.circleBackgroundColor,
        //   ),
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: positionedChildren,
        //   ),
        // ),
        child: GestureDetector(
          onPanStart: _onPanStart(xOrigin, yOrigin),
          onPanUpdate: _onPanUpdate(xOrigin, yOrigin),
          onPanEnd: _onPanEnd,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.circleBackgroundColor,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: positionedChildren,
            ),
          ),
        ));
  }
}

class CircularSelectorItem {
  final Widget child;
  VoidCallback onTap;

  CircularSelectorItem({required this.child, this.onTap = defaultMethod});

  static void defaultMethod() => {};
}

class DividerPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final double radius;
  final Color color;
  final double strokeWidth;

  DividerPainter({
    required this.startAngle,
    required this.endAngle,
    required this.radius,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, startAngle, endAngle - startAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
