import 'package:flutter/material.dart';

Widget leading(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}