import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Center(
            child: Image.asset('imgs/logo.jpeg'),
          ),
        ),
      ),
    );
  }
}
