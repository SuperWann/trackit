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

class InputForm extends StatelessWidget {
  final TextInputType type;
  final TextEditingController controller;

  const InputForm({super.key, required this.type, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enableSuggestions: true,
      keyboardType: type,
      decoration: InputDecoration(
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

class InputPassword extends StatefulWidget {
  final TextEditingController controller;

  const InputPassword({super.key, required this.controller});

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _isSecure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isSecure,
      decoration: InputDecoration(
        hintText: 'Masukkan password',
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
        suffixIcon: IconButton(
          icon: Icon(_isSecure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isSecure = !_isSecure;
            });
          },
        ),
      ),
      style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
    );
  }
}
