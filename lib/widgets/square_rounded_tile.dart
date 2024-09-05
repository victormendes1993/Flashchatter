import 'package:flutter/material.dart';

class SquareRoundedTile extends StatelessWidget {
  const SquareRoundedTile(
      {super.key, required this.imageName, required this.onPress});
  final VoidCallback onPress;

  final String imageName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15.0,
              offset: const Offset(6.0, 6.0),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(15.0),
        width: 75.0,
        height: 75.0,
        child: Material(
          child: Image.asset(
            imageName,
          ),
        ),
      ),
    );
  }
}
