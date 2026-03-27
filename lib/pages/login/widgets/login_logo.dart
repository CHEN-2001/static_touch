import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  final double size;

  const LoginLogo({super.key, this.size = 200.0});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/title.png', width: size, height: null, fit: BoxFit.fitWidth);
  }
}
