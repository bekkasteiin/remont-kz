import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HBox extends SizedBox {
  const HBox(double height, {Key? key}) : super(height: height, width: 0, key: key);
}

class WBox extends SizedBox {
  const WBox(double width, {Key? key}) : super(height: 0, width: width, key: key);
}

