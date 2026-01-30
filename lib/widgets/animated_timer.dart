import 'package:flutter/material.dart';

class AnimatedTimer extends StatefulWidget {
  final double progress;

  const AnimatedTimer({super.key, required this.progress});

  @override
  State<AnimatedTimer> createState() => _AnimatedTimerState();
}

class _AnimatedTimerState extends State<AnimatedTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: widget.progress,
            strokeWidth: 10,
            backgroundColor: const Color(0xFFF48FB1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
          ),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: const Icon(
              Icons.access_time,
              size: 50,
              color: Color(0xFFE91E63),
            ),
          ),
        ],
      ),
    );
  }
}