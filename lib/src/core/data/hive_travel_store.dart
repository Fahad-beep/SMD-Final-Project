import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/audit_event.dart';
import '../models/place.dart';
import '../models/settings.dart';
import '../models/weather.dart';
import 'travel_store.dart';

class HiveTravelStore implements TravelStore {
  HiveTravelStore._(
    this._placesBox,
    this._weatherBox,
    this._favoritesBox,
    this._settingsBox,
    this._eventsBox,
  );

  static Future<HiveTravelStore> open() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    final placesBox = await Hive.openBox('travel_places');
    final weatherBox = await Hive.openBox('travel_weather');
    final favoritesBox = await Hive.openBox('travel_favorites');
    final settingsBox = await Hive.openBox('travel_settings');
    final eventsBox = await Hive.openBox('travel_events');
    return HiveTravelStore._(
      placesBox,
      weatherBox,
      favoritesBox,
      settingsBox,
      eventsBox,
    );
  }

  final Box _placesBox;
  final Box _weatherBox;
  final Box _favoritesBox;
  final Box _settingsBox;
  final Box _eventsBox;

  @override
  Future<List<TravelPlace>> loadPlaces() async {
    final raw = _placesBox.get('places');
    if (raw is! String || raw.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map(TravelPlace.fromJson)
        .toList();
  }

  @override
  Future<void> savePlaces(List<TravelPlace> places) async {
    await _placesBox.put(
      'places',
      jsonEncode(places.map((place) => place.toJson()).toList()),
    );
  }

  @override
  Future<TravelWeather?> loadWeather(String placeId) async {
    final raw = _weatherBox.get(placeId);
    if (raw is! String || raw.isEmpty) {
      return null;
    }
    return TravelWeather.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveWeather(String placeId, TravelWeather weather) async {
    await _weatherBox.put(placeId, jsonEncode(weather.toJson()));
  }

  @override
  Future<Set<String>> loadFavorites() async {
    final raw = _favoritesBox.get('favorites');
    if (raw is! List) {
      return <String>{};
    }
    return raw.cast<String>().toSet();
  }

  @override
  Future<void> saveFavorites(Set<String> favorites) async {
    await _favoritesBox.put('favorites', favorites.toList());
  }

  @override
  Future<AppSettings> loadSettings() async {
    final raw = _settingsBox.get('settings');
    if (raw is Map) {
      return AppSettings.fromJson(raw.cast<String, dynamic>());
    }
    return AppSettings.defaults();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put('settings', settings.toJson());
  }

  @override
  Future<List<AuditEvent>> loadAuditEvents() async {
    final raw = _eventsBox.get('events');
    if (raw is! List) {
      return const [];
    }
    return raw
        .cast<Map>()
        .map((event) => AuditEvent.fromJson(event.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<void> saveAuditEvents(List<AuditEvent> events) async {
    await _eventsBox.put(
      'events',
      events.map((event) => event.toJson()).toList(),
    );
  }

  @override
  Future<void> clearTravelCache() async {
    await _placesBox.delete('places');
    await _weatherBox.clear();
  }
}
