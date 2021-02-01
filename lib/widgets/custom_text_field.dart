import 'package:flutter/material.dart';
import 'package:otodokekun_cource/helpers/style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType textInputType;
  final int maxLines;
  final String labelText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final Function onTap;

  CustomTextField({
    this.controller,
    this.obscureText,
    this.textInputType,
    this.maxLines,
    this.labelText,
    this.prefixIconData,
    this.suffixIconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      maxLines: maxLines,
      style: TextStyle(
        color: kMainColor,
        fontSize: 14.0,
      ),
      cursorColor: kMainColor,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18.0,
          color: kMainColor,
        ),
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Icon(
            suffixIconData,
            size: 18.0,
            color: kMainColor,
          ),
        ),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: kMainColor),
        ),
        labelStyle: TextStyle(color: kMainColor),
        focusColor: kMainColor,
      ),
    );
  }
}
