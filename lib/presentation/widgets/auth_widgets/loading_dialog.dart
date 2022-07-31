import 'package:flutter/material.dart';
import '../../../constants/palette.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: Colors.white,
      content: Container(
        height: 60.0,
        alignment: Alignment.centerLeft,
        child: Row(
          children: const [
            CircularProgressIndicator(
              color: Palette.tabColor,
            ),
            SizedBox(width: 15.0),
            Text(
              'Connecting',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
