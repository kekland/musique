import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musique/utils/theme_utils.dart';

class ExpressiveProgressBar extends StatefulWidget {
  const ExpressiveProgressBar({
    super.key,
    required this.progress,
    this.isActive = true,
  });

  final double progress;
  final bool isActive;

  @override
  State<ExpressiveProgressBar> createState() => _ExpressiveProgressBarState();
}

class _ExpressiveProgressBarState extends State<ExpressiveProgressBar> with TickerProviderStateMixin {
  late final _thetaController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final _amplitudeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    lowerBound: 0.0,
    upperBound: 1.0,
  )..value = widget.isActive ? 1.0 : 0.0;

  late final _amplitudeAnimation = CurvedAnimation(
    parent: _amplitudeController,
    curve: ElasticInOutCurve(0.3),
  );

  @override
  void initState() {
    super.initState();

    _thetaController.repeat();
    _thetaController.addListener(() => setState(() {}));
    _amplitudeController.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant ExpressiveProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _amplitudeController.forward();
      } else {
        _amplitudeController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _thetaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 4.0,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CustomPaint(
        painter: _ExpressiveProgressBarPainter(
          progress: widget.progress,
          theta: _thetaController.value,
          amplitude: _amplitudeAnimation.value,
          primary: context.colorScheme.primary,
          secondary: context.colorScheme.secondaryContainer,
        ),
      ),
    );
  }
}

class _ExpressiveProgressBarPainter extends CustomPainter {
  _ExpressiveProgressBarPainter({
    required this.progress,
    required this.amplitude,
    required this.theta,
    required this.primary,
    required this.secondary,
  });

  final double progress;
  final double amplitude;
  final double theta;
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = primary
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final dotPaint = Paint()
      ..color = primary
      ..style = PaintingStyle.fill;

    final backgroundLinePaint = Paint()
      ..color = secondary
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final path = Path();
    path.moveTo(0.0, size.height / 2 + sin(theta * pi * 2) * size.height / 2 * amplitude);

    for (var x = 0.0; x <= size.width * progress - 8.0; x += 1.0) {
      final y = size.height / 2 + sin(x / 4.0 + theta * pi * 2) * size.height / 2 * amplitude;
      path.lineTo(x, y);
    }

    canvas.drawLine(
      Offset(size.width * progress, size.height / 2),
      Offset(size.width - 8.0, size.height / 2),
      backgroundLinePaint,
    );

    canvas.drawCircle(Offset(size.width, size.height / 2), 4.0, dotPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
