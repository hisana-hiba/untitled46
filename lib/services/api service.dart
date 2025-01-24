
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/photo model.dart';


class ApiService {
  static const String _apiKey = 'ddnfcgajCIJLRT2xsWg35OAhoz6F7SfplN97QkAu0ygb9lJa2Vibbxyg';

  Future<List<PhotoModel>> fetchPopularPhotos(int page) async {
    final url = Uri.https('api.pexels.com', '/v1/curated', {
      'page': page.toString(),
      'per_page': '20',
    });

    final headers = {'Authorization': _apiKey};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['photos'] as List)
            .map((photo) => PhotoModel.fromJson(photo))
            .toList();
      } else {
        throw Exception('Failed to fetch photos');
      }
    } catch (e) {
      throw Exception('Error fetching photos: $e');
    }
  }
}
