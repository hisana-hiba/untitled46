import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestPage extends StatelessWidget {
  const PermissionRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'To download images, the app needs access to your storage.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Requesting storage permission
                PermissionStatus status = await Permission.storage.request();

                // Check if permission is granted
                if (status.isGranted) {
                  // Navigate to HomeScreen or continue the app flow
                  Navigator.pushReplacementNamed(context, '/home');
                } else if (status.isDenied) {
                  // Show dialog if permission is denied
                  _showPermissionDeniedDialog(context);
                } else if (status.isPermanentlyDenied) {
                  // Open settings if permission is permanently denied
                  openAppSettings();
                }
              },
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  // Show a dialog when permission is permanently denied
  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('You need to grant storage permission to download images.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
