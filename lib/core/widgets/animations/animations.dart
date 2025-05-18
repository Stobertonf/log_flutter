import 'package:flutter/material.dart';

class Animations extends StatefulWidget {
  final int duration;
  final Widget child;

  const Animations({
    super.key,
    required this.duration,
    required this.child,
  });

  @override
  _AnimationsState createState() => _AnimationsState();
}

class _AnimationsState extends State<Animations>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration,
      ),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(
            0.0,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      ),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
