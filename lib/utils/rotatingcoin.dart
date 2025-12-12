import 'package:flutter/material.dart';
import 'dart:math' as math;

class CoinRotateLoader extends StatefulWidget {
  final double size;
  const CoinRotateLoader({super.key, this.size = 70});

  @override
  State<CoinRotateLoader> createState() => _CoinRotateLoaderState();
}

class _CoinRotateLoaderState extends State<CoinRotateLoader>
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: Image.asset(
        "assets/images/coin.png",
        height: widget.size,
        width: widget.size,
      ),
    );
  }
}

// Step 3 — Use it anywhere

// Center(
//   child: CoinRotateLoader(size: 80),
// );