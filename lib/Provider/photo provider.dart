
import 'package:flutter/foundation.dart';
import '../Model/photo model.dart';

import '../services/api service.dart';

import '../utils/download helper.dart';


class PhotosProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final List<PhotoModel> _photos = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMorePhotos = true;
  String? _lastDownloadedPath;

  List<PhotoModel> get photos => _photos;
  bool get isLoading => _isLoading;
  bool get hasMorePhotos => _hasMorePhotos;
  String? get lastDownloadedPath => _lastDownloadedPath;

  // Fetch photos from the API
  Future<void> fetchPhotos() async {
    if (_isLoading || !_hasMorePhotos) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPhotos = await _apiService.fetchPopularPhotos(_currentPage);

      if (newPhotos.isEmpty) {
        _hasMorePhotos = false;
      } else {
        _photos.addAll(newPhotos);
        _currentPage++;
      }
    } catch (e) {
      print('Fetch Photos Error: $e');
      _hasMorePhotos = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> downloadImage(String imageUrl) async {
    try {
      final downloadPath = await DownloadHelper.downloadImage(imageUrl);

      if (downloadPath != null) {
        _lastDownloadedPath = downloadPath;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Download Error: $e');
      return false;
    }
  }


  void resetProvider() {
    _photos.clear();
    _currentPage = 1;
    _hasMorePhotos = true;
    _lastDownloadedPath = null;
    fetchPhotos();
  }
}

