import 'package:flutter/material.dart';
import 'package:get/get.dart';

PreferredSizeWidget appBar(String titulo, double height, Color primaryBlue) {
  return AppBar(
    toolbarHeight: height,
    backgroundColor: Colors.orange,
    elevation: 2,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: primaryBlue,
        size: 20,
      ),
      onPressed: () => Get.back(),
    ),
    title: Text(
      titulo,
      style: TextStyle(
        color: primaryBlue,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}
