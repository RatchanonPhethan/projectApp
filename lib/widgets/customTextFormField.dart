// ignore: camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class customTextFormField extends StatelessWidget {
  const customTextFormField({
    Key? key,
    this.hintText,
    this.obscureText,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.maxLength,
    this.maxLines,
    this.checkprice,
    this.prefixIcon,
    this.inputFormatters,
    this.onTap,
    this.enabled,
    this.onChange,
  }) : super(key: key);

  final TextEditingController controller;
  final bool? obscureText;
  final String? hintText;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final bool? checkprice;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Future<void>? Function()? onTap;
  final bool? enabled;
  final Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          style: const TextStyle(fontFamily: 'Itim'),
          obscuringCharacter: "*",
          obscureText: obscureText ?? false,
          inputFormatters: inputFormatters ?? [],
          validator: validator,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintText: hintText,
            counterText: "",
            labelText: hintText,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.blue)),
            labelStyle: const TextStyle(color: Colors.blue),
          ),
          onTap: onTap,
        ));
  }
}
