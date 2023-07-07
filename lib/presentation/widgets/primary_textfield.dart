import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? initialValue;
  final Function(String)? onChanged;
  const PrimaryTextField({Key? key, this.controller, required this.labelText,this.obscureText=false, this.validator, this.initialValue, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      onChanged: onChanged,
      initialValue: initialValue,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration:  InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
        ),
        labelText: labelText ,
      ),
    );
  }
}
