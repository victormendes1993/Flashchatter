import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.color,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 15.0),
  });

  final Color color;
  final String text;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            style: const TextStyle(
              color: Colors.white,
            ),
            text,
          ),
        ),
      ),
    );
  }
}
