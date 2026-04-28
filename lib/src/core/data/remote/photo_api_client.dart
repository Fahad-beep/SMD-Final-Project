import 'dart:convert';

import 'package:http/http.dart' as http;

class PhotoApiClient {
  PhotoApiClient(this._client);

  final http.Client _client;

  Future<List<Map<String, dynamic>>> fetchPhotos({int limit = 24}) async {
    final uri = Uri.https(
      'jsonplaceholder.typicode.com',
      '/photos',
      {'_limit': '$limit'},
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load photos');
    }
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map((item) => item.map((key, value) => MapEntry(key, value)))
        .toList();
  }
}
