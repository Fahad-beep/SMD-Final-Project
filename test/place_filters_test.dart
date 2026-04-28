import 'package:flutter_test/flutter_test.dart';

import 'package:smd_final_project/src/core/models/place.dart';
import 'package:smd_final_project/src/core/utils/place_filters.dart';

TravelPlace place({
  required String id,
  required String title,
  required String region,
  required String country,
  required String category,
  required double rating,
}) {
  return TravelPlace(
    id: id,
    title: title,
    region: region,
    country: country,
    category: category,
    description: '$title description',
    imageUrl: 'https://example.com/$id.jpg',
    thumbnailUrl: 'https://example.com/$id-thumb.jpg',
    latitude: 0,
    longitude: 0,
    rating: rating,
    sourcePhotoId: 1,
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  test('filters by query and favorites', () {
    final items = [
      place(
        id: 'a',
        title: 'Lake Tekapo',
        region: 'Oceania',
        country: 'New Zealand',
        category: 'Lake',
        rating: 4.9,
      ),
      place(
        id: 'b',
        title: 'Santorini',
        region: 'Europe',
        country: 'Greece',
        category: 'Coast',
        rating: 4.8,
      ),
    ];

    final filtered = filterPlaces(
      places: items,
      query: 'lake',
      region: '',
      category: '',
      favoritesOnly: false,
      favoriteIds: {'a'},
      sortMode: PlaceSortMode.recommended,
    );

    expect(filtered.single.id, 'a');
  });

  test('sorts alphabetically', () {
    final items = [
      place(
        id: 'b',
        title: 'Santorini',
        region: 'Europe',
        country: 'Greece',
        category: 'Coast',
        rating: 4.8,
      ),
      place(
        id: 'a',
        title: 'Lake Tekapo',
        region: 'Oceania',
        country: 'New Zealand',
        category: 'Lake',
        rating: 4.9,
      ),
    ];

    final filtered = filterPlaces(
      places: items,
      query: '',
      region: '',
      category: '',
      favoritesOnly: false,
      favoriteIds: const {},
      sortMode: PlaceSortMode.alphabetical,
    );

    expect(filtered.first.title, 'Lake Tekapo');
    expect(filtered.last.title, 'Santorini');
  });
}
