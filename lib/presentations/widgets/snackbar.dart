import 'package:flutter/material.dart';

snackbar(BuildContext context, String message, Color color, Color backgroundColor) {
  final snackBar = SnackBar(
    duration: const Duration(seconds: 4),
    backgroundColor: backgroundColor,
    content: Text(
      message,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'baloo da 2',
        color: color
      ),
    ),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}