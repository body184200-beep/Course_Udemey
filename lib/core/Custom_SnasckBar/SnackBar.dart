import 'package:fire_base/core/App_Colors/Colors.dart';
import 'package:flutter/material.dart';

enum SnackBarState { success, error, warning, info }
abstract class CustomSnackBar {
  static void showSnackBar(context, String message, SnackBarState state) {
    Color backgroundColor;
    switch (state) {
      case SnackBarState.success:
        backgroundColor = AppColors.green;
      case SnackBarState.error:
        backgroundColor = AppColors.red;
      case SnackBarState.warning:
        backgroundColor = AppColors.orange;
      case SnackBarState.info:
        backgroundColor = AppColors.blue;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: AppColors.white, fontSize: 16.0),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}