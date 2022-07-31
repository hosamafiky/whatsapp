import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  final String text;
  final IconData icon;
  const ButtonCard({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23.0,
        backgroundColor: const Color(0xFF00C853),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
