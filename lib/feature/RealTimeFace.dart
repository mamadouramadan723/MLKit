import 'dart:math';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../main.dart';

class RealTimeFaceDetectionPage extends StatefulWidget {
  const RealTimeFaceDetectionPage({super.key});

  @override
  State<RealTimeFaceDetectionPage> createState() =>
      _RealTimeFaceDetectionPageState();
}

class _RealTimeFaceDetectionPageState extends State<RealTimeFaceDetectionPage>
    with SingleTickerProviderStateMixin {
  late CameraController controller;
  late Size size;
  CameraImage? img;
  List<Face>? _scannedFaces;
  late FaceDetector faceDetector;
  bool isBusy = false;
  late CameraDescription description = cameras[0];
  late CameraLensDirection camDirection = CameraLensDirection.back;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    initializeCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    faceDetector.close();
    _animationController.dispose();
    super.dispose();
  }

  toggleCameraDirection() async {
    await _animationController.forward();
    if (camDirection == CameraLensDirection.back) {
      description = cameras[1];
      camDirection = CameraLensDirection.front;
    } else {
      description = cameras[0];
      camDirection = CameraLensDirection.back;
    }
    await controller.stopImageStream();
    initializeCamera();
    await _animationController.reverse();
  }

  initializeCamera() async {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
    );
    faceDetector = FaceDetector(options: options);
    controller = CameraController(description, ResolutionPreset.high);
    await controller.initialize().then((_) {
      if (!mounted) return;
      controller.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          img = image;
          doFaceDetectionOnFrame();
        }
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        print('Camera Error: ${e.description}');
      }
    });
  }

  doFaceDetectionOnFrame() async {
    InputImage frameImg = getInputImage();
    List<Face> faces = await faceDetector.processImage(frameImg);
    setState(() {
      isBusy = false;
      _scannedFaces = faces;
    });
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());
    final camera = description;
    final imageRotation =
    InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    final inputImageFormat =
    InputImageFormatValue.fromRawValue(img!.format.raw);

    final planeData = img!.planes.map(
          (Plane plane) {
        return InputImageMetadata(
          bytesPerRow: plane.bytesPerRow,
          size: imageSize,
          rotation: imageRotation!,
          format: inputImageFormat!,
        );
      },
    ).toList();

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: planeData[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
  }

  Widget buildResult() {
    if (_scannedFaces == null || !controller.value.isInitialized) {
      return const Text('');
    }
    final Size imgSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter paint =
    FaceDetectorPainter(imgSize, _scannedFaces!, camDirection);
    return CustomPaint(
      painter: paint,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    stackChildren.add(
      Positioned(
        height: size.height - 250.0,
        width: size.width,
        top: 0.0,
        left: 0.0,
        child: Transform(
          transform: Matrix4.rotationY(
              camDirection == CameraLensDirection.front ? pi : 0),
          alignment: Alignment.center,
          child: CameraPreview(controller),
        ),
      ),
    );

    stackChildren.add(
      Positioned(
        top: 0,
        width: size.width,
        height: size.height - 250,
        left: 0,
        child: buildResult(),
      ),
    );

    stackChildren.add(
      Positioned(
        top: size.height - 250,
        left: 0,
        width: size.width,
        height: 250,
        child: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.cached),
              iconSize: 50,
              color: Colors.black,
              onPressed: toggleCameraDirection,
            ),
            if (_scannedFaces != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Detected Faces: ${_scannedFaces!.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Face Detector',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        color: Colors.transparent,
        child: Stack(
          children: stackChildren,
        ),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImgSize, this.faces, this.camDire);

  List<Face> faces;
  final Size absoluteImgSize;
  final CameraLensDirection camDire;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImgSize.width;
    final double scaleY = size.height / absoluteImgSize.height;

    Paint rectPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.green
      ..strokeWidth = 6.0;

    Paint landmarkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 4.0;

    for (Face face in faces) {
      // Draw bounding box
      canvas.drawRect(
          Rect.fromLTRB(
            (camDire == CameraLensDirection.front)
                ? (absoluteImgSize.width - face.boundingBox.right) * scaleX
                : face.boundingBox.left * scaleX,
            face.boundingBox.top * scaleY,
            (camDire == CameraLensDirection.front)
                ? (absoluteImgSize.width - face.boundingBox.left) * scaleX
                : face.boundingBox.right * scaleX,
            face.boundingBox.bottom * scaleY,
          ),
          rectPaint);

      // Draw face landmarks (eyes, nose, mouth, etc.)
      void drawLandmark(FaceLandmark? landmark) {
        if (landmark == null) return;
        final offset = Offset(
          (camDire == CameraLensDirection.front)
              ? (absoluteImgSize.width - landmark.position.x) * scaleX
              : landmark.position.x * scaleX,
          landmark.position.y * scaleY,
        );
        canvas.drawCircle(offset, 4, landmarkPaint);
      }

      drawLandmark(face.landmarks[FaceLandmarkType.leftEye]);
      drawLandmark(face.landmarks[FaceLandmarkType.rightEye]);
      drawLandmark(face.landmarks[FaceLandmarkType.noseBase]);
      drawLandmark(face.landmarks[FaceLandmarkType.leftMouth]);
      drawLandmark(face.landmarks[FaceLandmarkType.rightMouth]);

      // Draw contours
      for (FaceContourType type in FaceContourType.values) {
        final contour = face.contours[type];
        if (contour?.points != null) {
          final points = contour!.points.map((point) {
            return Offset(
              (camDire == CameraLensDirection.front)
                  ? (absoluteImgSize.width - point.x.toDouble()) * scaleX
                  : point.x.toDouble() * scaleX,
              point.y.toDouble() * scaleY,
            );
          }).toList();
          canvas.drawPoints(ui.PointMode.points, points, rectPaint);
        }
      }

      // Display face emotions with more nuanced labels
      String emotionText;
      if (face.smilingProbability != null) {
        final smileProb = face.smilingProbability!;
        if (smileProb > 0.8) {
          emotionText = '😁 Very Happy';
        } else if (smileProb > 0.6) {
          emotionText = '😊 Happy';
        } else if (smileProb > 0.4) {
          emotionText = '🙂 Content';
        } else if (smileProb > 0.2) {
          emotionText = '😐 Neutral';
        } else {
          emotionText = '😟 Sad';
        }
      } else {
        emotionText = '😐 Neutral';
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: emotionText,
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          face.boundingBox.left * scaleX,
          (face.boundingBox.top - 10) * scaleY,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
