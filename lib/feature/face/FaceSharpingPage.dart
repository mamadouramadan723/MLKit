import 'package:flutter/material.dart';

import 'face_detector_page.dart';

class FaceSharpingPage extends StatefulWidget {
  const FaceSharpingPage({super.key});

  @override
  State<FaceSharpingPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FaceSharpingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: ElevatedButton(
              child: const Text("Open Camera"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FaceDetectorPage(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
