import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText, labelText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final Function suffixOnTap;
  final controller;
  final bool autoFocus;

  const TextFieldWidget({
    Key key,
    this.hintText,
    this.labelText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.suffixOnTap,
    this.controller,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.teal),
        focusColor: Theme.of(context).primaryColor,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.teal),
        ),
        labelText: (labelText == null) ? hintText : labelText,
        hintText: (labelText == null) ? null : hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        suffixIcon: GestureDetector(
          onTap: suffixOnTap,
          child: Icon(
            suffixIconData,
            size: 18,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      autofocus: autoFocus,
    );
  }
}
