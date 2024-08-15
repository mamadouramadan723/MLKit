import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  State<FaceDetectionPage> createState() => FaceDetectionPageState();
}

class FaceDetectionPageState extends State<FaceDetectionPage> {
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  InputImage? inputImage;

  void selectImage() async {
    final pickedPhoto = await picker.pickImage(source: ImageSource.gallery);
    if (pickedPhoto == null) return;

    final photoFile = File(pickedPhoto.path);
    setState(() {
      imageFile = photoFile;
      inputImage = InputImage.fromFile(photoFile);
    });
  }

  Future<List<Face>> getFaces() async {
    if (inputImage == null) return List.empty();

    final FaceDetector faceDetector = FaceDetector(
        options:
            FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));

    return await faceDetector.processImage(inputImage!);
  }

  Future<int> getFacesDetectedNum() async {
    final faces = await getFaces();

    return faces.length;
  }

  Future<List<Image>> getFacesImages() async {
    final faces = await getFaces();
    if (faces.isEmpty) return List.empty();

    List<Map<String, int>> faceMaps = [];
    for (Face face in faces) {
      int x = face.boundingBox.left.toInt();
      int y = face.boundingBox.top.toInt();
      int w = face.boundingBox.width.toInt();
      int h = face.boundingBox.height.toInt();

      Map<String, int> thisMap = {'x': x, 'y': y, 'w': w, 'h': h};
      faceMaps.add(thisMap);
    }

    List<Image> faceImages = [];
    final bytes = await imageFile!.readAsBytes();
    final image = img.decodeImage(bytes);
    for (Map<String, int> faceMap in faceMaps) {
      final faceCrop = img.copyCrop(image!,
          x: faceMap['x']!,
          y: faceMap['y']!,
          width: faceMap['w']!,
          height: faceMap['h']!);

      final faceImg = img.encodeJpg(faceCrop);
      final imgWidget = Image.memory(
        faceImg,
        cacheWidth: 600,
        cacheHeight: 600,
        fit: BoxFit.cover,
      );
      faceImages.add(imgWidget);
    }

    return faceImages;
  }

  @override
  Widget build(BuildContext context) => MainAppView(this);
}

class MainAppView extends StatelessWidget {
  const MainAppView(this.state, {super.key});

  final FaceDetectionPageState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('face detection tester yes'),
              ElevatedButton(
                  onPressed: state.selectImage,
                  child: const Text("select image")),
              FutureBuilder(
                future: state.getFacesDetectedNum(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.toString());
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              FutureBuilder(
                future: state.getFacesImages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<Image> images = snapshot.data!;

                    return Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: images.map((e) {
                          return Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child: e,
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
