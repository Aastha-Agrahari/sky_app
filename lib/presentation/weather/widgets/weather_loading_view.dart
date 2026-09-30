import 'package:flutter/material.dart';

/// Skeleton placeholder with a soft pulse while data is loading.
class WeatherLoadingView extends StatefulWidget {
  const WeatherLoadingView({super.key});

  @override
  State<WeatherLoadingView> createState() => _WeatherLoadingViewState();
}

class _WeatherLoadingViewState extends State<WeatherLoadingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        children: [
          const Center(child: _Bone(width: 130, height: 130, circle: true)),
          const SizedBox(height: 24),
          const Center(child: _Bone(width: 170, height: 84, radius: 24)),
          const SizedBox(height: 14),
          const Center(child: _Bone(width: 120, height: 20)),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(child: _Bone(height: 70, radius: 20)),
              SizedBox(width: 12),
              Expanded(child: _Bone(height: 70, radius: 20)),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(child: _Bone(height: 70, radius: 20)),
              SizedBox(width: 12),
              Expanded(child: _Bone(height: 70, radius: 20)),
            ],
          ),
          const SizedBox(height: 16),
          const _Bone(height: 130, radius: 24),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Fetching the latest weather…',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, this.radius = 12, this.circle = false});

  final double? width;
  final double height;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}
