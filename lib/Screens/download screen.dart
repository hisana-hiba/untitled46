import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DownloadedImagesScreen extends StatefulWidget {
  const DownloadedImagesScreen({Key? key}) : super(key: key);

  @override
  _DownloadedImagesScreenState createState() => _DownloadedImagesScreenState();
}

class _DownloadedImagesScreenState extends State<DownloadedImagesScreen> {
  List<File> _downloadedImages = [];

  @override
  void initState() {
    super.initState();
    _loadDownloadedImages();
  }

  Future<void> _loadDownloadedImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();

      setState(() {
        _downloadedImages = files
            .where((file) =>
        file.path.toLowerCase().endsWith('.jpg') ||
            file.path.toLowerCase().endsWith('.png'))
            .map((file) => File(file.path))
            .toList();
      });
    } catch (e) {
      print('Error loading downloaded images: $e');
    }
  }

  Future<void> _deleteImage(File image) async {
    try {
      await image.delete();
      setState(() {
        _downloadedImages.remove(image);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image deleted')),
      );
    } catch (e) {
      print('Error deleting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloaded Images'),
      ),
      body: _downloadedImages.isEmpty
          ? const Center(child: Text('No downloaded images'))
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _downloadedImages.length,
        itemBuilder: (context, index) {
          final image = _downloadedImages[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Implement full-screen image view
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Image.file(
                        image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          blurRadius: 2.0
                      )
                    ],
                  ),
                  onPressed: () => _deleteImage(image),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}