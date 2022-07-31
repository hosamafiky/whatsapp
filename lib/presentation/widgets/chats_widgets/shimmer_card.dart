// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/presentation/widgets/chats_widgets/shimmer_widget.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const ShimmerWidget.circular(width: 60.0, height: 60.0),
          title: Align(
            alignment: Alignment.centerLeft,
            child: ShimmerWidget.rectangular(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 16.0,
            ),
          ),
          subtitle: const ShimmerWidget.rectangular(height: 14.0),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 80.0, right: 20.0),
          child: Divider(
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}
