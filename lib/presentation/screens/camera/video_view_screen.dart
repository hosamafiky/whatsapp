import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewScreen extends StatefulWidget {
  static const String routeName = '/video-view';
  final String path;
  const VideoViewScreen(this.path, {Key? key}) : super(key: key);

  @override
  State<VideoViewScreen> createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.path))
      ..initialize().then((value) => setState(() => {}));
  }

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
              child: _videoPlayerController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    )
                  : Container(),
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
