import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'video_view_screen.dart';
import 'camera_view_screen.dart';

List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  static const String routeName = '/camera';
  final String? receiverId;
  const CameraScreen({
    Key? key,
    this.receiverId,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  bool isRecording = false;

  void takePicture(BuildContext context) async {
    cameraController!.takePicture().then((value) {
      Navigator.pushNamed(
        context,
        CameraViewScreen.routeName,
        arguments: {
          'path': value.path,
          'receiverId': widget.receiverId,
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(cameras![0], ResolutionPreset.high);
  }

  @override
  void dispose() {
    super.dispose();
    cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraController!.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                    width: double.infinity,
                    child: CameraPreview(cameraController!));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          cameraController!.stopVideoRecording().then((value) {
                            setState(() {
                              isRecording = false;
                            });
                            Navigator.pushNamed(
                              context,
                              VideoViewScreen.routeName,
                              arguments: value.path,
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.flash_off,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => !isRecording ? takePicture(context) : {},
                        onLongPress: () async {
                          cameraController!.startVideoRecording().then((value) {
                            setState(() {
                              isRecording = true;
                            });
                          });
                        },
                        onLongPressUp: () {},
                        child: isRecording
                            ? const Icon(
                                Icons.radio_button_on,
                                color: Colors.red,
                                size: 80.0,
                              )
                            : const Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70.0,
                              ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Hold for video, tap for photo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
