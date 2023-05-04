// ignore: camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class customTextFormField extends StatelessWidget {
  const customTextFormField({
    Key? key,
    required this.hintText,
    this.obscureText,
    required this.controller,
    this.validator,
    this.maxLength,
    this.maxLines,
    this.checkprice,
  }) : super(key: key);

  final TextEditingController controller;
  final bool? obscureText;
  final String hintText;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final bool? checkprice;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        child: TextFormField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          obscuringCharacter: "*",
          obscureText: obscureText ?? false,
          validator: validator,
          decoration: InputDecoration(
              hintText: hintText,
              counterText: "",
              labelText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              )),
        ));
  }
}
