import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/palette.dart';

class OtherStatusCard extends StatelessWidget {
  final String image;
  final String name;
  final String time;
  final bool isSeen;
  final int numOfStatus;
  const OtherStatusCard({
    Key? key,
    required this.image,
    required this.name,
    required this.time,
    required this.isSeen,
    required this.numOfStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomPaint(
        painter: StatusPainter(
          isSeen: isSeen,
          numOfStatus: numOfStatus,
        ),
        child: CircleAvatar(
          radius: 28.0,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 26.0,
            backgroundImage: AssetImage(image),
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      ),
      subtitle: Text('Today, $time'),
    );
  }
}

class StatusPainter extends CustomPainter {
  final bool isSeen;
  final int numOfStatus;
  StatusPainter({required this.numOfStatus, required this.isSeen});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 4.0
      ..color = isSeen ? Colors.grey : Palette.tabColor
      ..style = PaintingStyle.stroke;

    drawArc(canvas, size, paint);
  }

  double degreeToRadians(double degree) {
    return degree * pi / 180;
  }

  void drawArc(Canvas canvas, Size size, Paint paint) {
    if (numOfStatus == 1) {
      canvas.drawArc(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        degreeToRadians(0),
        degreeToRadians(360),
        false,
        paint,
      );
    } else {
      double degree = -90;
      double arc = 360 / numOfStatus;

      for (var i = 0; i < numOfStatus; i++) {
        canvas.drawArc(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          degreeToRadians(degree + 4),
          degreeToRadians(arc - 8),
          false,
          paint,
        );
        degree += arc;
      }
    }
  }

  @override
  bool shouldRepaint(StatusPainter oldDelegate) => true;
}
