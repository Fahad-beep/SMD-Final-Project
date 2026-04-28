import 'package:http/http.dart' as http;

import '../models/audit_event.dart';
import '../models/place.dart';
import '../models/settings.dart';
import '../models/weather.dart';
import '../utils/weather_codes.dart';
import 'place_seed.dart';
import 'remote/location_image_client.dart';
import 'remote/photo_api_client.dart';
import 'remote/weather_api_client.dart';
import 'travel_store.dart';

class TravelRepository {
  TravelRepository({
    required http.Client client,
    required TravelStore store,
  })  : _client = client,
        _store = store,
        _photoClient = PhotoApiClient(client),
        _locationImageClient = LocationImageClient(client),
        _weatherClient = WeatherApiClient(client);

  final http.Client _client;
  final TravelStore _store;
  final PhotoApiClient _photoClient;
  final LocationImageClient _locationImageClient;
  final WeatherApiClient _weatherClient;

  Future<List<TravelPlace>> loadCachedPlaces() {
    return _store.loadPlaces();
  }

  Future<List<TravelPlace>> fetchPlaces({int limit = 24}) async {
    final now = DateTime.now();
    try {
      final photos = await _photoClient.fetchPhotos(limit: limit);
      final imageUrls = await Future.wait(
        photos.asMap().entries.map((entry) {
          final seed = travelSeeds[entry.key % travelSeeds.length];
          return _resolveImageUrl(seed: seed);
        }),
      );
      final places = photos.asMap().entries.map((entry) {
        final seed = travelSeeds[entry.key % travelSeeds.length];
        final photo = entry.value;
        return TravelPlace(
          id: seed.id,
          title: seed.title,
          region: seed.region,
          country: seed.country,
          category: seed.category,
          description: seed.description,
          imageUrl: imageUrls[entry.key],
          thumbnailUrl: photo['thumbnailUrl'] as String,
          latitude: seed.latitude,
          longitude: seed.longitude,
          rating: seed.rating,
          sourcePhotoId: photo['id'] as int,
          createdAt: now.subtract(Duration(minutes: entry.key)),
        );
      }).toList();
      await _store.savePlaces(places);
      await _store.saveAuditEvents([
        ...await _store.loadAuditEvents(),
        AuditEvent(
          id: now.microsecondsSinceEpoch.toString(),
          title: 'Travel feed refreshed',
          details: '${places.length} places loaded from the remote feed.',
          category: 'sync',
          createdAt: now,
        ),
      ]);
      return places;
    } catch (_) {
      final cached = await _store.loadPlaces();
      if (cached.isNotEmpty) {
        await _store.saveAuditEvents([
          ...await _store.loadAuditEvents(),
          AuditEvent(
            id: now.microsecondsSinceEpoch.toString(),
            title: 'Travel feed restored from cache',
            details:
                'The live feed was unavailable, so cached travel places were shown.',
            category: 'sync',
            createdAt: now,
          ),
        ]);
        return cached;
      }

      final fallback = _buildSeedPlaces(limit: limit, createdAt: now);
      await _store.savePlaces(fallback);
      await _store.saveAuditEvents([
        ...await _store.loadAuditEvents(),
        AuditEvent(
          id: now.microsecondsSinceEpoch.toString(),
          title: 'Built-in travel samples loaded',
          details:
              'Local destination samples were prepared because the live feed could not be reached.',
          category: 'sync',
          createdAt: now,
        ),
      ]);
      return fallback;
    }
  }

  Future<TravelPlace?> findPlaceById(String id) async {
    final cached = await _store.loadPlaces();
    for (final place in cached) {
      if (place.id == id) {
        return place;
      }
    }
    final refreshed = await fetchPlaces();
    for (final place in refreshed) {
      if (place.id == id) {
        return place;
      }
    }
    return null;
  }

  Future<TravelWeather> fetchWeather(TravelPlace place) async {
    final cached = await _store.loadWeather(place.id);
    try {
      final weather = await _weatherClient.fetchWeather(
        placeId: place.id,
        latitude: place.latitude,
        longitude: place.longitude,
      );
      await _store.saveWeather(place.id, weather);
      return weather;
    } catch (_) {
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  Future<TravelWeather?> loadCachedWeather(String placeId) {
    return _store.loadWeather(placeId);
  }

  Future<Set<String>> loadFavorites() {
    return _store.loadFavorites();
  }

  Future<void> saveFavorites(Set<String> favorites) {
    return _store.saveFavorites(favorites);
  }

  Future<AppSettings> loadSettings() {
    return _store.loadSettings();
  }

  Future<void> saveSettings(AppSettings settings) {
    return _store.saveSettings(settings);
  }

  Future<List<AuditEvent>> loadAuditEvents() {
    return _store.loadAuditEvents();
  }

  Future<void> recordEvent(String title, String details,
      {String category = 'info'}) async {
    final events = await _store.loadAuditEvents();
    events.insert(
      0,
      AuditEvent(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        details: details,
        category: category,
        createdAt: DateTime.now(),
      ),
    );
    await _store.saveAuditEvents(events.take(40).toList());
  }

  Future<void> clearCache() async {
    await _store.clearTravelCache();
  }

  WeatherCodeInfo weatherInfo(int code) => weatherCodeInfo(code);

  void dispose() {
    _client.close();
  }

  List<TravelPlace> _buildSeedPlaces({
    required int limit,
    required DateTime createdAt,
  }) {
    return List.generate(limit, (index) {
      final seed = travelSeeds[index % travelSeeds.length];
      return TravelPlace(
        id: seed.id,
        title: seed.title,
        region: seed.region,
        country: seed.country,
        category: seed.category,
        description: seed.description,
        imageUrl:
            'https://source.unsplash.com/featured/1600x900/?${Uri.encodeComponent('${seed.title} ${seed.country}')}',
        thumbnailUrl:
            'https://source.unsplash.com/featured/400x300/?${Uri.encodeComponent('${seed.title} ${seed.country}')}',
        latitude: seed.latitude,
        longitude: seed.longitude,
        rating: seed.rating,
        sourcePhotoId: 0,
        createdAt: createdAt.subtract(Duration(minutes: index)),
      );
    });
  }

  Future<String> _resolveImageUrl({
    required TravelSeed seed,
  }) async {
    final wikiUrl = await _locationImageClient.fetchImageUrl(
      title: seed.title,
      country: seed.country,
      category: seed.category,
    );
    if (wikiUrl != null && wikiUrl.isNotEmpty) {
      return wikiUrl;
    }
    return 'https://source.unsplash.com/featured/1600x900/?${Uri.encodeComponent('${seed.title} ${seed.country} travel')}';
  }
}
