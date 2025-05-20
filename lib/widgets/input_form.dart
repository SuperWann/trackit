import 'package:flutter/material.dart';

class InputFormWithHintText extends StatelessWidget {
  final String text;
  final TextInputType type;
  final TextEditingController controller;

  const InputFormWithHintText({
    super.key,
    required this.type,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    
    return TextField(
      controller: controller,
      enableSuggestions: true,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          color: Colors.black26,
        ),
        filled: true,
        fillColor: Color.fromARGB(255, 233, 233, 233),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}
