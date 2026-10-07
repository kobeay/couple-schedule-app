import 'dart:math' as math;

import 'package:couple_schedule_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CoupleAnimation extends StatefulWidget {
  const CoupleAnimation({super.key});

  @override
  State<CoupleAnimation> createState() => CoupleAnimationState();
}

class CoupleAnimationState extends State<CoupleAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: SizedBox(
            width: 120,
            height: 100,
            child: AnimatedBuilder(
              animation: _controller,
              child: Image.asset(
                'assets/images/login_couple.png',
                width: 120,
                height: 60,
                fit: BoxFit.contain,
              ),
              builder: (context, child) {
                final phase = _controller.value;

                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 4,
                      child: Transform.translate(
                        offset: Offset(0, math.sin(phase * 2 * math.pi) * 2),
                        child: child,
                      ),
                    ),
                    _buildHeart(phase, left: 32, size: 11, delay: 0),
                    _buildHeart(phase, left: 57, size: 9, delay: 0.25),
                    _buildHeart(phase, left: 81, size: 10, delay: 0.5),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeart(
    double phase, {
    required double left,
    required double size,
    required double delay,
  }) {
    final progress = (phase - delay + 1) % 1;
    // 양 끝에서 투명해져 반복 시 위치가 돌아와도 튀지 않습니다.
    final opacity = math.sin(progress * math.pi) * 0.75;

    return Positioned(
      left: left,
      top: 32 - progress * 22,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Icon(
          Icons.favorite,
          size: size,
          color: AppColors.partnerSchedule,
        ),
      ),
    );
  }
}
