import 'package:flutter/material.dart';
import 'package:mlkit/sidebar.dart';

import 'feature/BarcodeScanningPage.dart';
import 'feature/FaceDetectionPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ML Kit APIs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ML Kit APIs'),
      routes: {
        '/barcode_scanning': (context) => BarcodeScanningPage(),
        '/face_detection': (context) => FaceDetectionPage(),
        // Add more routes for other features
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Main Page'),
      ),
      drawer: Sidebar(),
    );
  }
}
