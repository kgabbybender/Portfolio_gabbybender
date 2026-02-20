import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(60, (_) => Particle(_random));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            for (var p in _particles) {
              p.update();
            }
            return CustomPaint(
              painter: ParticlePainter(_particles),
              child: const SizedBox.expand(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  late double x, y, vx, vy, radius, opacity;
  final Random random;

  Particle(this.random) {
    _reset();
  }

  void _reset() {
    x = random.nextDouble();
    y = random.nextDouble();
    vx = (random.nextDouble() - 0.5) * 0.0008;
    vy = (random.nextDouble() - 0.5) * 0.0008;
    radius = random.nextDouble() * 2 + 0.5;
    opacity = random.nextDouble() * 0.5 + 0.1;
  }

  void update() {
    x += vx;
    y += vy;
    if (x < 0 || x > 1) vx = -vx;
    if (y < 0 || y > 1) vy = -vy;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var p in particles) {
      paint.color = AppColors.primaryPurple.withOpacity(p.opacity);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        paint,
      );
    }

    // Draw connecting lines between nearby particles
    final linePaint = Paint()..strokeWidth = 0.3;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = (particles[i].x - particles[j].x) * size.width;
        final dy = (particles[i].y - particles[j].y) * size.height;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < 120) {
          linePaint.color = AppColors.primaryPurple.withOpacity(
            (1 - dist / 120) * 0.15,
          );
          canvas.drawLine(
            Offset(particles[i].x * size.width, particles[i].y * size.height),
            Offset(particles[j].x * size.width, particles[j].y * size.height),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
