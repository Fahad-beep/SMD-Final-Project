import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationImageClient {
  LocationImageClient(this._client);

  final http.Client _client;

  Future<String?> fetchImageUrl({
    required String title,
    required String country,
    required String category,
  }) async {
    final query = '$title $country $category';
    final uri = Uri.https('en.wikipedia.org', '/w/api.php', {
      'action': 'query',
      'generator': 'search',
      'gsrsearch': query,
      'gsrlimit': '1',
      'prop': 'pageimages|info',
      'piprop': 'thumbnail',
      'pithumbsize': '1400',
      'inprop': 'url',
      'redirects': '1',
      'format': 'json',
      'formatversion': '2',
    });

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      return null;
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final queryResult = decoded['query'];
    if (queryResult is! Map<String, dynamic>) {
      return null;
    }
    final pages = queryResult['pages'];
    if (pages is! List || pages.isEmpty) {
      return null;
    }

    final first = pages.first;
    if (first is! Map<String, dynamic>) {
      return null;
    }
    final thumbnail = first['thumbnail'];
    if (thumbnail is Map<String, dynamic>) {
      final source = thumbnail['source'];
      if (source is String && source.isNotEmpty) {
        return source;
      }
    }
    return null;
  }
}
