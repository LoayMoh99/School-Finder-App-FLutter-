import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final Function suffixOnTap;
  final controller;

  TextFieldWidget({
    this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.suffixOnTap,
    this.controller,
  });

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
        labelText: hintText,
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
    );
  }
}
