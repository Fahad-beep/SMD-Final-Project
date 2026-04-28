import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:smd_final_project/src/core/data/place_seed.dart';
import 'package:smd_final_project/src/core/data/travel_repository.dart';
import 'package:smd_final_project/src/core/data/travel_store.dart';
import 'package:smd_final_project/src/core/models/audit_event.dart';
import 'package:smd_final_project/src/core/models/place.dart';
import 'package:smd_final_project/src/core/models/settings.dart';
import 'package:smd_final_project/src/core/models/weather.dart';

class FakeTravelStore implements TravelStore {
  List<TravelPlace> places = [];
  final Map<String, TravelWeather> weather = {};
  Set<String> favorites = {};
  AppSettings settings = AppSettings.defaults();
  List<AuditEvent> events = [];

  @override
  Future<void> clearTravelCache() async {
    places = [];
    weather.clear();
  }

  @override
  Future<List<TravelPlace>> loadPlaces() async => places;

  @override
  Future<TravelWeather?> loadWeather(String placeId) async => weather[placeId];

  @override
  Future<Set<String>> loadFavorites() async => favorites;

  @override
  Future<AppSettings> loadSettings() async => settings;

  @override
  Future<List<AuditEvent>> loadAuditEvents() async => events;

  @override
  Future<void> saveAuditEvents(List<AuditEvent> events) async {
    this.events = events;
  }

  @override
  Future<void> saveFavorites(Set<String> favorites) async {
    this.favorites = favorites;
  }

  @override
  Future<void> savePlaces(List<TravelPlace> places) async {
    this.places = places;
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    this.settings = settings;
  }

  @override
  Future<void> saveWeather(String placeId, TravelWeather weather) async {
    this.weather[placeId] = weather;
  }
}

void main() {
  test('fetchPlaces maps the photo API into travel places', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'jsonplaceholder.typicode.com');
      return http.Response(
        jsonEncode([
          {
            'id': 1,
            'title': 'Photo 1',
            'url': 'https://example.com/1.jpg',
            'thumbnailUrl': 'https://example.com/1-thumb.jpg'
          },
          {
            'id': 2,
            'title': 'Photo 2',
            'url': 'https://example.com/2.jpg',
            'thumbnailUrl': 'https://example.com/2-thumb.jpg'
          },
        ]),
        200,
      );
    });

    final store = FakeTravelStore();
    final repository = TravelRepository(client: client, store: store);
    final places = await repository.fetchPlaces(limit: 2);

    expect(places, hasLength(2));
    expect(places.first.title, travelSeeds.first.title);
    expect(places.first.imageUrl, 'https://example.com/1.jpg');
    expect(store.places, hasLength(2));
  });

  test('findPlaceById falls back to cached data', () async {
    final client = MockClient((request) async {
      return http.Response('[]', 200);
    });
    final store = FakeTravelStore()
      ..places = [
        TravelPlace(
          id: 'lake-tekapo',
          title: 'Lake Tekapo',
          region: 'Oceania',
          country: 'New Zealand',
          category: 'Lake',
          description: 'Cached',
          imageUrl: 'https://example.com/1.jpg',
          thumbnailUrl: 'https://example.com/1-thumb.jpg',
          latitude: -44.0036,
          longitude: 170.4761,
          rating: 4.9,
          sourcePhotoId: 1,
          createdAt: DateTime(2024, 1, 1),
        ),
      ];
    final repository = TravelRepository(client: client, store: store);

    final place = await repository.findPlaceById('lake-tekapo');

    expect(place?.title, 'Lake Tekapo');
  });

  test('fetchPlaces falls back to built-in samples when the API fails', () async {
    final client = MockClient((request) async {
      throw Exception('network unavailable');
    });
    final store = FakeTravelStore();
    final repository = TravelRepository(client: client, store: store);

    final places = await repository.fetchPlaces(limit: 3);

    expect(places, hasLength(3));
    expect(places.first.sourcePhotoId, 0);
    expect(places.first.imageUrl, isEmpty);
    expect(store.places, hasLength(3));
    expect(store.events.last.title, 'Built-in travel samples loaded');
  });
}
