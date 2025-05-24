import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {
  final String text;
  final String color;
  final String colorText;
  final VoidCallback onPressed;

  const LongButton({
    super.key,
    required this.text,
    required this.color,
    required this.colorText,
    required this.onPressed,
  });

  Color _hexToColor(String hexColor) {
    final hex = hexColor.replaceAll("#", "");
    return Color(int.parse("FF$hex", radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _hexToColor(color),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _hexToColor(colorText),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }
}
