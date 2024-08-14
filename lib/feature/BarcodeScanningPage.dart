import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';

class BarcodeScanningPage extends StatefulWidget {
  const BarcodeScanningPage({super.key});

  @override
  BarcodeScanningPageState createState() => BarcodeScanningPageState();
}

class BarcodeScanningPageState extends State<BarcodeScanningPage> {
  File? _image;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  List<Barcode> _barcodes = [];

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
        _barcodes = barcodes;
      });
    }
  }

  void _copyBarcodeValue(String value) {
    log('Copied: $value');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied: $value'),
        duration: Duration(seconds: 2),
        // Other properties like duration, action, etc.
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
          Expanded(
            child: _image != null
                ? Image.file(_image!)
                : const Center(child: Text('No image selected')),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _barcodes.length,
              itemBuilder: (context, index) {
                final barcode = _barcodes[index];
                return ListTile(
                  title: SelectableText(barcode.rawValue!),
                  subtitle: Text(barcode.format.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copyBarcodeValue(barcode.rawValue!),
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
