import 'package:flutter/material.dart';

class TimeLineWidgetContainer extends StatelessWidget {
  final Widget child;
  final Widget leftIcon;
  final bool isFirst;
  final bool isLast;
  const TimeLineWidgetContainer(
      {super.key,
      required this.child,
      required this.isFirst,
      required this.isLast,
      required this.leftIcon});

  @override
  Widget build(BuildContext context) {
    const margin = TimelineBoxDecoration.iconSize;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: TimelineBoxDecoration(isFirst: isFirst, isLast: isLast),
            width: TimelineBoxDecoration.iconSize,
            alignment: Alignment.center,
            child: leftIcon,
          ),
          Container(
              constraints: BoxConstraints(
                  minHeight: margin, maxWidth: constraints.maxWidth - margin),
              child: child),
        ],
      );
    });
  }
}

class TimelineBoxDecoration extends Decoration {
  static const double lineGap = 6.0;
  static const double iconSize = 18.0;
  final bool isFirst;
  final bool isLast;
  const TimelineBoxDecoration({required this.isFirst, required this.isLast});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return TimelinePainterLeft(isFirst: isFirst, isLast: isLast);
  }
}

abstract class _TimelinePainter extends BoxPainter {
  final Paint linePaint;
  final Paint circlePaint;
  final bool isFirst;
  final bool isLast;

  _TimelinePainter({required this.isFirst, required this.isLast})
      : linePaint = Paint()
          ..color = const Color(0xFFD0D8F8)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
        circlePaint = Paint()
          ..color = const Color(0xFFCCCCCC)
          ..style = PaintingStyle.fill;
}

class TimelinePainterLeft extends _TimelinePainter {
  TimelinePainterLeft({required super.isFirst, required super.isLast});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    double iconMargin =
        TimelineBoxDecoration.iconSize / 2 + TimelineBoxDecoration.lineGap;
    double leftMargin = TimelineBoxDecoration.iconSize / 2;

    final leftOffset = Offset(leftMargin, offset.dy);
    final Offset? top = configuration.size?.topLeft(Offset(leftOffset.dx, 0));
    final Offset? centerTop = configuration.size
        ?.centerLeft(Offset(leftOffset.dx, leftOffset.dy - iconMargin));
    final Offset? centerBottom = configuration.size
        ?.centerLeft(Offset(leftOffset.dx, leftOffset.dy + iconMargin));
    final Offset? end = configuration.size
        ?.bottomLeft(Offset(leftOffset.dx, leftOffset.dy * 2));
    if (!isFirst && top != null && centerTop != null) {
      canvas.drawLine(top, centerTop, linePaint);
    }
    if (!isLast && centerBottom != null && end != null) {
      canvas.drawLine(centerBottom, end, linePaint);
    }
  }
}
