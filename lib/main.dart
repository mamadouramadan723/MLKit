import 'package:flutter/material.dart';
import 'package:mlkit/sidebar.dart';

import 'feature/BarcodeScanningPage.dart';
import 'feature/FaceDetectionPage.dart';
import 'feature/face/Shape.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ML Kit APIs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ML Kit APIs'),
      routes: {
        '/barcode_scanning': (context) => const BarcodeScanningPage(),
        '/face_detection': (context) => const Shapes(),
        // Add more routes for other features
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text('Main Page'),
      ),
      drawer: const Sidebar(),
    );
  }
}
