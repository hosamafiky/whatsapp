// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        highlightColor: Colors.grey[200]!,
        baseColor: Colors.grey[400]!,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey,
            shape: shapeBorder,
          ),
        ),
      );
}
