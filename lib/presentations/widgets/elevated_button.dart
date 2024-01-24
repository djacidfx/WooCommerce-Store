import 'package:flutter/material.dart';

ElevatedButton elevatedButton({
  required IconData icon,
  required String text,
  required VoidCallback onPressed,
  Color? backgroundColor,
  Color? iconColor,
  Color? textColor,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      primary: backgroundColor ?? Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      fixedSize: const Size(double.infinity, 50)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor ?? Colors.white),
        const SizedBox(width: 10),
        Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: 16, color: textColor ?? Colors.white, fontFamily: 'Baloo Da 2'),
        ),
      ],
    ),
  );
}