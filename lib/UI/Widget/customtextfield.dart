import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String) onSaved;
  final String label;
  final String hint;
  final bool obscure;
  final Widget suffixIcon;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.onSaved,
    required this.label,
    this.obscure = false,
    required this.suffixIcon,
    this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.inputType = TextInputType.text,
    required this.hint,
    this.validator, required String? Function(dynamic value) onValidate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        // onSaved: onSaved,
        keyboardType: inputType,
        textCapitalization: textCapitalization,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          hintStyle: const TextStyle(color: Colors.white),
          hintText: hint,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
