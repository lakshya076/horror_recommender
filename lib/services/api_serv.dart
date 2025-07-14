import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApiService {
  final String baseUrl = 'https://horror-recommender-backend.onrender.com';

  Future<int?> searchMovieId(String query) async {
    final url = Uri.parse('$baseUrl/search/$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['id'];
    } else {
      return null;
    }
  }

  Future<List<int>> getRecommendations(int movieId) async {
    final url = Uri.parse('$baseUrl/recommend');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'movie_id': movieId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> recommended = data['recommendations'];
      return recommended.cast<int>();
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMetadata (
    List<int> movieIds,
  ) async {
    final url = Uri.parse('$baseUrl/metadata_batch');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'movie_ids': movieIds}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getSingleMetadata(int movieId) async {
    final url = Uri.parse('$baseUrl/metadata/$movieId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
