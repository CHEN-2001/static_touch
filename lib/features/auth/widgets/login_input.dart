import 'package:flutter/material.dart';

class LoginInput extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;

  const LoginInput({super.key, required this.label, this.isPassword = false, this.controller});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  late bool _isObscured;
  static final _enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xFFF2E7C2)),
  );

  static final _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xFFfecc46)),
  );

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        ),
        const SizedBox(height: 8),

        TextField(
          controller: widget.controller,
          obscureText: _isObscured,
          cursorColor: const Color(0xFF8B2323),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),

            suffixIcon: widget.isPassword ? _buildVisibilityToggle() : null,

            enabledBorder: _enabledBorder,
            focusedBorder: _focusedBorder,
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildVisibilityToggle() {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          _isObscured ? Icons.visibility_off : Icons.visibility,
          key: ValueKey<bool>(_isObscured),
          color: const Color(0xFFF2E7C2),
        ),
      ),
      onPressed: () {
        setState(() {
          _isObscured = !_isObscured;
        });
      },
    );
  }
}
