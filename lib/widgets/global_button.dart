// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class GlobalButton extends StatelessWidget {
  final String buttonText;
  final IconData iconData;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double borderRadius;

  const GlobalButton({
    required this.buttonText,
    required this.iconData,
    required this.onPressed,
    this.width = 150.0,
    this.height = 45.0,
    this.borderRadius = 45.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size(width, height),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText,
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          const SizedBox(width: 8.0),
          Icon(iconData,color: Colors.black,),
        ],
      ),
    );
  }
}
