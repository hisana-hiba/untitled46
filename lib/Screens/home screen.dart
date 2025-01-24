// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../Provider/photo provider.dart';
// import '../utils/download helper.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<PhotosProvider>(context, listen: false).fetchPhotos();
//     });
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent * 0.9) {
//       Provider.of<PhotosProvider>(context, listen: false).fetchPhotos();
//     }
//   }
//
//   Future<void> _downloadImage(BuildContext context, String imageUrl) async {
//     final scaffoldMessenger = ScaffoldMessenger.of(context);
//
//     scaffoldMessenger.showSnackBar(
//       const SnackBar(content: Text('Downloading high-resolution image...')),
//     );
//
//     final success = await DownloadHelper.downloadImage(imageUrl);
//
//     if (success != null) {
//       scaffoldMessenger.showSnackBar(
//         SnackBar(content: Text('Image downloaded to $success')),
//       );
//     } else {
//       scaffoldMessenger.showSnackBar(
//         const SnackBar(content: Text('Download failed')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Center(child: const Text('Wallpaper App'))),
//       body: Consumer<PhotosProvider>(
//         builder: (context, photosProvider, child) {
//           if (photosProvider.isLoading && photosProvider.photos.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (photosProvider.photos.isEmpty) {
//             return const Center(
//               child: Text('No photos found. Check your internet connection.'),
//             );
//           }
//
//           return GridView.builder(
//             controller: _scrollController,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.7,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//             ),
//             itemCount: photosProvider.photos.length +
//                 (photosProvider.isLoading ? 1 : 0),
//             itemBuilder: (context, index) {
//               if (index >= photosProvider.photos.length) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               final photo = photosProvider.photos[index];
//               return GestureDetector(
//                 onTap: () => _downloadImage(context, photo.src.original),
//                 child: Card(
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.network(
//                         photo.src.medium,
//                         fit: BoxFit.cover,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return const Center(child: CircularProgressIndicator());
//                         },
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(Icons.error);
//                         },
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           color: Colors.black54,
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             photo.photographer,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../Provider/photo provider.dart';
// import '../utils/download helper.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<PhotosProvider>(context, listen: false).fetchPhotos();
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       Provider.of<PhotosProvider>(context, listen: false).fetchPhotos();
//     }
//   }
//
//   Future<void> _downloadImage(BuildContext context, String imageUrl) async {
//     final path = await DownloadHelper.downloadImage(imageUrl);
//     final message = path != null
//         ? 'Image downloaded to $path'
//         : 'Failed to download image';
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Wallpaper App'),
//         backgroundColor: Colors.black,
//       ),
//       body: Consumer<PhotosProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading && provider.photos.isEmpty) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (provider.photos.isEmpty) {
//             return Center(child: Text('No images available.'));
//           }
//
//           return GridView.builder(
//             controller: _scrollController,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//               childAspectRatio: 0.7,
//             ),
//             itemCount: provider.photos.length,
//             itemBuilder: (context, index) {
//               final photo = provider.photos[index];
//               return GestureDetector(
//                 onTap: () => _downloadImage(context, photo.src.original),
//                 child: Image.network(
//                   photo.src.medium,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(child: CircularProgressIndicator());
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
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



