import 'dart:io';

import 'package:flutter/material.dart';

class CameraViewScreen extends StatefulWidget {
  static const String routeName = '/camera-view';
  final String path;
  const CameraViewScreen(this.path, {Key? key}) : super(key: key);

  @override
  State<CameraViewScreen> createState() => _CameraViewScreenState();
}

class _CameraViewScreenState extends State<CameraViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.crop_rotate),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.emoji_emotions_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.title),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 140.0,
              child: Image.file(
                File(widget.path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  minLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add caption..',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                    prefixIcon: const Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                      size: 27.0,
                    ),
                    suffixIcon: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.tealAccent[700],
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 27.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
