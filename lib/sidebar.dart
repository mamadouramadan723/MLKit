import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'ML Kit APIs',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Barcode Scanning'),
            onTap: () {
              // Navigate to BarcodeScanningPage
              Navigator.pushNamed(context, '/barcode_scanning');
            },
          ),
          ListTile(
            title: Text('Face Detection'),
            onTap: () {
              // Navigate to FaceDetectionPage
              Navigator.pushNamed(context, '/face_detection');
            },
          ),
          // Add more ListTile items for other features
        ],
      ),
    );
  }
}
