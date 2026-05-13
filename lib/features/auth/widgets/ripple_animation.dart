import 'package:flutter/material.dart';

class RippleAnimation extends StatefulWidget {
  final Widget child;
  final Color color;
  final double size;
  final Duration duration;

  const RippleAnimation({
    super.key,
    required this.child,
    this.color = const Color(0xFFD4AF37),
    this.size = 250.0,
    this.duration = const Duration(milliseconds: 4000),
  });

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 创建动画控制器并立即开始循环播放
    _controller = AnimationController(duration: widget.duration, vsync: this)..repeat();
  }

  @override
  void dispose() {
    // 释放动画控制器，防止内存泄漏
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // RepaintBoundary：将波纹绘制隔离到独立图层，动画重绘时不触发父组件和子组件重建
      child: CustomPaint(
        painter: _RipplePainter(animation: _controller, color: widget.color),
        child: Container(width: widget.size, height: widget.size, alignment: Alignment.center, child: widget.child),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  // 复用 Paint 对象，避免每帧重复创建
  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  // super(repaint: animation)：动画值变化时自动触发 paint 方法重绘
  _RipplePainter({required this.animation, required this.color}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = size.width / 2;

    // 绘制两层波纹（错开半个周期）
    for (int wave = 1; wave >= 0; wave--) {
      _drawWave(canvas, center, maxRadius, wave);
    }
  }

  // 计算并绘制单层波纹
  void _drawWave(Canvas canvas, Offset center, double maxRadius, int wave) {
    // 计算当前进度 (0.0 → 1.0)，两层错开 0.5 周期
    double progress = (animation.value + wave / 2) % 1.0;

    // 透明度：开始时不透明，逐渐消失
    double opacity = (1.0 - progress).clamp(0.0, 1.0);

    // 半径：从 30% 扩散到 100%
    double radius = maxRadius * (0.3 + progress * 0.7);

    _paint.color = color.withValues(alpha: opacity);

    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    // 仅当颜色变化时才重建 Painter 对象
    return oldDelegate.color != color;
  }
}
