import '../models/place.dart';

enum PlaceSortMode { recommended, alphabetical, region, recent }

List<TravelPlace> filterPlaces({
  required List<TravelPlace> places,
  required String query,
  required String region,
  required String category,
  required bool favoritesOnly,
  required Set<String> favoriteIds,
  required PlaceSortMode sortMode,
}) {
  final normalizedQuery = query.trim().toLowerCase();

  final filtered = places.where((place) {
    final matchesQuery = normalizedQuery.isEmpty ||
        place.title.toLowerCase().contains(normalizedQuery) ||
        place.region.toLowerCase().contains(normalizedQuery) ||
        place.country.toLowerCase().contains(normalizedQuery) ||
        place.category.toLowerCase().contains(normalizedQuery) ||
        place.description.toLowerCase().contains(normalizedQuery);
    final matchesRegion = region.isEmpty || place.region == region;
    final matchesCategory = category.isEmpty || place.category == category;
    final matchesFavorite = !favoritesOnly || favoriteIds.contains(place.id);
    return matchesQuery && matchesRegion && matchesCategory && matchesFavorite;
  }).toList();

  filtered.sort((a, b) {
    return switch (sortMode) {
      PlaceSortMode.recommended => b.rating.compareTo(a.rating),
      PlaceSortMode.alphabetical => a.title.compareTo(b.title),
      PlaceSortMode.region => a.region.compareTo(b.region),
      PlaceSortMode.recent => b.createdAt.compareTo(a.createdAt),
    };
  });

  return filtered;
}
