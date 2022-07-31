import 'package:flutter/material.dart';
import '../../../constants/palette.dart';

class ConfirmNumberDialog extends StatelessWidget {
  final String number;
  final VoidCallback onEditPressed;
  final VoidCallback onOkeyPressed;
  const ConfirmNumberDialog(
    this.number, {
    Key? key,
    required this.onEditPressed,
    required this.onOkeyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: Colors.white,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You entered the phone number:',
            style: TextStyle(color: Colors.grey[800]),
          ),
          const SizedBox(height: 15.0),
          Text(
            '+$number',
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            'Is this OK, or would you like to edit the number?',
            style: TextStyle(color: Colors.grey[800]),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: onEditPressed,
          child: const Text(
            'EDIT',
            style: TextStyle(color: Palette.tabColor),
          ),
        ),
        TextButton(
          onPressed: onOkeyPressed,
          child: const Text(
            'OK',
            style: TextStyle(color: Palette.tabColor),
          ),
        ),
      ],
    );
  }
}
