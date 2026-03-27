import 'package:flutter/material.dart';

//NFC动画效果
class RippleAnimation extends StatefulWidget {
  final Widget child;
  final Color color;

  const RippleAnimation({super.key, required this.child, this.color = const Color(0xFFD4AF37)});

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // 1. 变慢：将时间从 2000ms 延长到 4000ms（4秒一个循环）
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RipplePainter(_controller, widget.color),
      child: Container(
        // 2. 变得更大：为了防止波纹被切断，容器给到 250
        width: 250,
        height: 250,
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Animation<double> _animation;
  final Color color;

  _RipplePainter(this._animation, this.color) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);

    // 3. 不密集：将原本的 3 层波纹减少为 2 层，间距自然变大
    for (int wave = 1; wave >= 0; wave--) {
      _drawWave(canvas, rect, wave);
    }
  }

  void _drawWave(Canvas canvas, Rect rect, int wave) {
    // 4. 这里的 wave / 2 配合上面的循环，确保两层波纹各占 50% 的时间差
    double progress = (_animation.value + wave / 2) % 1.0;

    // 5. 消失得更自然：透明度随进度线性下降
    double opacity = (1.0 - progress).clamp(0.0, 1.0);

    // 6. 扩散范围：让半径从 30% 起步，扩散到 100% (rect.width / 2)
    double radius = (rect.width / 2) * (0.3 + progress * 0.7);

    final Paint paint = Paint()
      // ignore: deprecated_member_use
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5; // 线条稍微细一点，更有禅意

    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) => true;
}
