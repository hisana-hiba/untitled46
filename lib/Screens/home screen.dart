
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../Provider/photo provider.dart';
import '../utils/download helper.dart';
import 'download screen.dart';
 // We'll create this new screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotosProvider>(context, listen: false).fetchPhotos();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      Provider.of<PhotosProvider>(context, listen: false).fetchPhotos();
    }
  }

  // Method to download the image and show a message
  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    final photosProvider = Provider.of<PhotosProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('Downloading high-resolution image...')),
    );

    final success = await photosProvider.downloadImage(imageUrl);

    if (success) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Image downloaded to ${photosProvider.lastDownloadedPath}')),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Download failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Navigate to Downloaded Images Screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DownloadedImagesScreen()
                  )
              );
            },
          ),
        ],
      ),
      body: Consumer<PhotosProvider>(
        builder: (context, photosProvider, child) {
          if (photosProvider.isLoading && photosProvider.photos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (photosProvider.photos.isEmpty) {
            return const Center(
              child: Text('No photos found. Check your internet connection.'),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: photosProvider.photos.length +
                (photosProvider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= photosProvider.photos.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final photo = photosProvider.photos[index];
              return GestureDetector(
                onTap: () => _downloadImage(context, photo.src.original),
                child: Card(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        photo.src.medium,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



