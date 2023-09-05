import 'package:flutter/material.dart';

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
