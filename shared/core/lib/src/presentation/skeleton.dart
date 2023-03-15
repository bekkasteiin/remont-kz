import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    Key? key,
    this.height = 8,
    this.width = double.maxFinite,
    this.linearGradient = skeletonGradient,
    this.radius,
    this.child,
  }) : super(key: key);

  final double height;
  final double width;
  final double? radius;
  final LinearGradient linearGradient;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(gradient: linearGradient);
    Widget body = Container(
      width: width,
      height: height,
      decoration: decoration,
      child: child,
    );

    if (radius != null) {
      body = ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius!)),
        child: body,
      );
    }

    return Shimmer.fromColors(
      child: body,
      baseColor: Color(0xFFF1F2F3),
      highlightColor: Colors.white,
    );
  }

  static const skeletonGradient = LinearGradient(
    colors: [
      Color(0xFFF9F9F9),
      Color(0xFFE9E9E9),
    ],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );
}
