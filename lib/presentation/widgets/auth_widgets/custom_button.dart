import 'package:flutter/material.dart';
import '../../../constants/palette.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double width;
  final double? textSize;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.width = double.infinity,
    this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: Palette.tabColor,
        minimumSize: Size(width, 50.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: textSize,
        ),
      ),
    );
  }
}
