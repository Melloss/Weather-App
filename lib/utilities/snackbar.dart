import 'package:get/get.dart';
import 'package:flutter/material.dart' show EdgeInsets, Color, Colors;

showSnackbar(String title, String message,
    {Color? color, double? horizontalMargin}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    margin:
        EdgeInsets.symmetric(vertical: 30, horizontal: horizontalMargin ?? 15),
    colorText: color ?? Colors.white,
  );
}
