import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String error;
  const ErrorDialog({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        error,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
