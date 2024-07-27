import 'package:flutter/material.dart';
import 'dart:math';

class CircularSelector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final parentWidth = MediaQuery.of(context).size.width;
    final parentHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;
    final xOrigin = (min(parentWidth, parentHeight) / radiusDividend * 2) / 2;
    final yOrigin = (min(parentWidth, parentHeight) / radiusDividend * 2) / 2;

    Point getPosition(
        int index, double childSize, double xOrigin, double yOrigin) {
      final double radius = min(parentWidth, parentHeight) / radiusDividend;
      final angle = 2 * pi * index / children.length;
      final dx = xOrigin + radius * cos(-(angle - pi / 2)) + childSize / 2;
      final dy = yOrigin + radius * sin(-(angle - pi / 2)) + childSize / 2;
      return Point(dx, dy);
    }

    List<Widget> positionedChildren = [];

    // Add divider lines
    for (int i = 0; i < children.length; i++) {
      final startAngle = 2 * pi * i / children.length;
      final endAngle = 2 * pi * (i + 1) / children.length;

      positionedChildren.add(
        CustomPaint(
          painter: DividerPainter(
            startAngle: startAngle,
            endAngle: endAngle,
            radius: min(parentWidth, parentHeight) / radiusDividend,
            color: dividerColor,
            strokeWidth: dividerWidth,
          ),
          size: Size(
            min(parentWidth, parentHeight) / radiusDividend * 2,
            min(parentWidth, parentHeight) / radiusDividend * 2,
          ),
        ),
      );
    }

    // Add child widgets
    for (int i = 0; i < children.length; i++) {
      final position = getPosition(i, childSize, xOrigin, yOrigin);
      final child = children[i].child;
      final positionedChild = Positioned(
        left: position.x.toDouble(),
        bottom: position.y.toDouble(),
        child: MouseRegion(
          onEnter: (event) => print("Hovering over item $i"),
          onExit: (event) => print("Exited item $i"),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: children[i].onTap,
            child: Container(
              width: childSize,
              height: childSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Center(child: child),
            ),
          ),
        ),
      );
      positionedChildren.add(positionedChild);
    }

    return SizedBox(
      width:
          min(parentWidth, parentHeight) / radiusDividend * 2 + childSize * 2,
      height:
          min(parentWidth, parentHeight) / radiusDividend * 2 + childSize * 2,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circleBackgroundColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: positionedChildren,
        ),
      ),
    );
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
