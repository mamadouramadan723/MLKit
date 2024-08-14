import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class BarcodeScanningPage extends StatefulWidget {
  const BarcodeScanningPage({super.key});

  @override
  BarcodeScanningPageState createState() => BarcodeScanningPageState();
}

class BarcodeScanningPageState extends State<BarcodeScanningPage> {
  File? _image;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  List<String> _scannedResults = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _scanBarcodes();
    }
  }

  Future<void> _scanBarcodes() async {
    if (_image != null) {
      final inputImage = InputImage.fromFilePath(_image!.path);
      final List<Barcode> barcodes =
      await _barcodeScanner.processImage(inputImage);
      setState(() {
        _scannedResults =
            barcodes.map((barcode) => barcode.rawValue!).toList();
      });
    }
  }

  Future<void> _scanFromCamera() async {
    try {
      final result = await scanner.scan();
      if (result != null) {
        setState(() {
          _scannedResults = [result];
        });
      } else {
        setState(() {
          _scannedResults = ['No barcode scanned'];
        });
      }
    } catch (e) {
      setState(() {
        _scannedResults = ['Error: $e'];
      });
    }
  }

  void _copyBarcodeValue(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $value'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Barcode Scanning'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _scanFromCamera,
                child: const Text('Scan from Camera'),
              ),
            ],
          ),
          if (_image != null)
            Expanded(
              child: Image.file(_image!),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _scannedResults.length,
              itemBuilder: (context, index) {
                final result = _scannedResults[index];
                return ListTile(
                  title: SelectableText(result),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copyBarcodeValue(result),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
