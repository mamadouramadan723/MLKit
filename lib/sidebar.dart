import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'ML Kit APIs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('flutter_mlkit@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'ML',
                style: TextStyle(fontSize: 24.0, color: Colors.blue),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.blueAccent.withOpacity(0.6), BlendMode.dstATop),
                image: AssetImage('assets/myLogo.png'), // Add a background image
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text('Barcode Scanning'),
            onTap: () {
              Navigator.pushNamed(context, '/barcode_scanning');
            },
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Face Detection'),
            onTap: () {
              Navigator.pushNamed(context, '/face_detection');
            },
          ),
          ListTile(
            leading: Icon(Icons.face_retouching_natural),
            title: Text('Real Time Face Detection'),
            onTap: () {
              Navigator.pushNamed(context, '/realtime_face_detection');
            },
          ),
          ListTile(
            leading: Icon(Icons.face_retouching_natural),
            title: Text('Face Mesh Detection'),
            onTap: () {
              Navigator.pushNamed(context, '/face_mesh_detection');
            },
          ),
          ListTile(
            leading: Icon(Icons.text_snippet),
            title: Text('Text Recognition V2'),
            onTap: () {
              Navigator.pushNamed(context, '/text_recognition');
            },
          ),
          ListTile(
            leading: Icon(Icons.label),
            title: Text('Image Labeling'),
            onTap: () {
              Navigator.pushNamed(context, '/image_labeling');
            },
          ),
          ListTile(
            leading: Icon(Icons.track_changes),
            title: Text('Object Detection and Tracking'),
            onTap: () {
              Navigator.pushNamed(context, '/object_detection');
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Digital Ink Recognition'),
            onTap: () {
              Navigator.pushNamed(context, '/digital_ink_recognition');
            },
          ),
          ListTile(
            leading: Icon(Icons.accessibility_new),
            title: Text('Pose Detection'),
            onTap: () {
              Navigator.pushNamed(context, '/pose_detection');
            },
          ),
          ListTile(
            leading: Icon(Icons.self_improvement),
            title: Text('Selfie Segmentation'),
            onTap: () {
              Navigator.pushNamed(context, '/selfie_segmentation');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Subject Segmentation'),
            onTap: () {
              Navigator.pushNamed(context, '/subject_segmentation');
            },
          ),
          ListTile(
            leading: Icon(Icons.scanner),
            title: Text('Document Scanner'),
            onTap: () {
              Navigator.pushNamed(context, '/document_scanner');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language Identification'),
            onTap: () {
              Navigator.pushNamed(context, '/language_identification');
            },
          ),
          ListTile(
            leading: Icon(Icons.translate),
            title: Text('On-Device Translation'),
            onTap: () {
              Navigator.pushNamed(context, '/on_device_translation');
            },
          ),
          ListTile(
            leading: Icon(Icons.reply),
            title: Text('Smart Reply'),
            onTap: () {
              Navigator.pushNamed(context, '/smart_reply');
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Entity Extraction'),
            onTap: () {
              Navigator.pushNamed(context, '/entity_extraction');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & Support'),
            onTap: () {
              Navigator.pushNamed(context, '/help_support');
            },
          ),
        ],
      ),
    );
  }
}
