import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:cardapio/configs/theme/colors.dart';

class CustomSnackBar {
  static void showDefault(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CustomColors.boxShadowColor,
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CustomColors.fontSecundaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
