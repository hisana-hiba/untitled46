
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadHelper {

  static Future<String?> downloadImage(String imageUrl) async {
    if (kIsWeb) {
      print('Download not supported on web');
      return null;
    }

    try {

      if (!await _checkPermissions()) {
        print('Permission check failed');
        return null;
      }

      final dio = Dio();
      final directory = await _getDownloadDirectory();

      if (directory == null) {
        print('Could not find download directory');
        return null;
      }

      final filename = 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savePath = '${directory.path}/$filename';

      print('Save path: $savePath');

      // Downloading the image
      await dio.download(
        imageUrl,
        savePath,
        options: Options(
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      return savePath;
    } catch (e) {
      print('Download Error: $e');
      return null;
    }
  }


  static Future<bool> _checkPermissions() async {
    if (!kIsWeb) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return false;
  }


  static Future<Directory?> _getDownloadDirectory() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      print('Directory retrieval error: $e');
      return null;
    }
  }
}



