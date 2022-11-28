import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_last_surprice/screens/home_screen.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initualizeControllerFuture;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initualizeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Take a picture"),
      ),
      body: FutureBuilder<void>(
        future: _initualizeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final image = await _controller.takePicture();
              final rute = image.name;
              Directory? documentDirectory =
                  await getExternalStorageDirectory();
              String path = join(documentDirectory!.path, rute);
              await _initualizeControllerFuture;

              image.saveTo(path);

              if (!mounted) {
                return;
              }
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(
                      firstCamera: widget.camera, imagePath: image.path)));
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt)),
    );
  }
}
