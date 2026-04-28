import '../models/audit_event.dart';
import '../models/place.dart';
import '../models/settings.dart';
import '../models/weather.dart';

abstract class TravelStore {
  Future<List<TravelPlace>> loadPlaces();
  Future<void> savePlaces(List<TravelPlace> places);
  Future<TravelWeather?> loadWeather(String placeId);
  Future<void> saveWeather(String placeId, TravelWeather weather);
  Future<Set<String>> loadFavorites();
  Future<void> saveFavorites(Set<String> favorites);
  Future<AppSettings> loadSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<List<AuditEvent>> loadAuditEvents();
  Future<void> saveAuditEvents(List<AuditEvent> events);
  Future<void> clearTravelCache();
}
