import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/travel_repository.dart';
import '../data/travel_store.dart';
import '../models/audit_event.dart';
import '../models/place.dart';
import '../models/settings.dart';
import '../models/weather.dart';
import '../utils/place_filters.dart';

final travelStoreProvider = Provider<TravelStore>((ref) {
  throw UnimplementedError('TravelStore must be provided by main');
});

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final travelRepositoryProvider = Provider<TravelRepository>((ref) {
  final repository = TravelRepository(
    client: ref.watch(httpClientProvider),
    store: ref.watch(travelStoreProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
});

class TravelFeedState {
  const TravelFeedState({
    this.allPlaces = const [],
    this.favorites = const <String>{},
    this.searchQuery = '',
    this.regionFilter = '',
    this.categoryFilter = '',
    this.sortMode = PlaceSortMode.recommended,
    this.favoritesOnly = false,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isOffline = false,
    this.errorMessage,
    this.lastSync,
  });

  final List<TravelPlace> allPlaces;
  final Set<String> favorites;
  final String searchQuery;
  final String regionFilter;
  final String categoryFilter;
  final PlaceSortMode sortMode;
  final bool favoritesOnly;
  final bool isLoading;
  final bool isRefreshing;
  final bool isOffline;
  final String? errorMessage;
  final DateTime? lastSync;

  List<TravelPlace> get visiblePlaces => filterPlaces(
        places: allPlaces,
        query: searchQuery,
        region: regionFilter,
        category: categoryFilter,
        favoritesOnly: favoritesOnly,
        favoriteIds: favorites,
        sortMode: sortMode,
      );

  TravelFeedState copyWith({
    List<TravelPlace>? allPlaces,
    Set<String>? favorites,
    String? searchQuery,
    String? regionFilter,
    String? categoryFilter,
    PlaceSortMode? sortMode,
    bool? favoritesOnly,
    bool? isLoading,
    bool? isRefreshing,
    bool? isOffline,
    String? errorMessage,
    bool clearError = false,
    DateTime? lastSync,
  }) {
    return TravelFeedState(
      allPlaces: allPlaces ?? this.allPlaces,
      favorites: favorites ?? this.favorites,
      searchQuery: searchQuery ?? this.searchQuery,
      regionFilter: regionFilter ?? this.regionFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      sortMode: sortMode ?? this.sortMode,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isOffline: isOffline ?? this.isOffline,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      lastSync: lastSync ?? this.lastSync,
    );
  }
}

class TravelFeedController extends StateNotifier<TravelFeedState> {
  TravelFeedController({
    required TravelRepository repository,
    required AppSettingsController settingsController,
  })  : _repository = repository,
        _settingsController = settingsController,
        super(const TravelFeedState()) {
    unawaited(loadInitial());
  }

  final TravelRepository _repository;
  final AppSettingsController _settingsController;

  Future<void> loadInitial() async {
    await _settingsController.loadInitial();
    state = state.copyWith(isLoading: true, clearError: true);
    final favorites = await _repository.loadFavorites();
    final settings = _settingsController.state;
    final cachedPlaces = await _repository.loadCachedPlaces();

    if (settings.previewMode == AppPreviewMode.error) {
      state = state.copyWith(
        favorites: favorites,
        allPlaces: const [],
        isLoading: false,
        isOffline: false,
        errorMessage: 'Preview mode is set to error.',
        lastSync: DateTime.now(),
      );
      return;
    }

    if (settings.previewMode == AppPreviewMode.empty) {
      state = state.copyWith(
        favorites: favorites,
        allPlaces: const [],
        isLoading: false,
        isOffline: false,
        clearError: true,
        lastSync: DateTime.now(),
      );
      return;
    }

    if (cachedPlaces.isNotEmpty) {
      state = state.copyWith(
        favorites: favorites,
        allPlaces: cachedPlaces,
        isLoading: settings.previewMode == AppPreviewMode.live,
        isOffline: settings.previewMode == AppPreviewMode.offline,
        clearError: true,
        lastSync: DateTime.now(),
      );
    } else {
      state = state.copyWith(
        favorites: favorites,
        isLoading: true,
        clearError: true,
      );
    }

    if (settings.previewMode == AppPreviewMode.offline) {
      state = state.copyWith(
        isLoading: false,
        isOffline: true,
        errorMessage: cachedPlaces.isEmpty
            ? 'No cached places are available for offline mode.'
            : null,
      );
      return;
    }

    try {
      final places = await _repository.fetchPlaces();
      state = state.copyWith(
        favorites: favorites,
        allPlaces: places,
        isLoading: false,
        isRefreshing: false,
        isOffline: false,
        clearError: true,
        lastSync: DateTime.now(),
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        isOffline: true,
        errorMessage: cachedPlaces.isEmpty
            ? 'Unable to load travel places. Pull to retry.'
            : 'Showing the last cached travel places.',
      );
    }
  }

  Future<void> refresh() async {
    final settings = _settingsController.state;
    if (settings.previewMode == AppPreviewMode.empty) {
      state = state.copyWith(allPlaces: const [], clearError: true);
      return;
    }
    if (settings.previewMode == AppPreviewMode.error) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: 'Preview mode is set to error.',
        isOffline: false,
      );
      return;
    }

    state = state.copyWith(isRefreshing: true, clearError: true);
    try {
      final places = await _repository.fetchPlaces();
      state = state.copyWith(
        allPlaces: places,
        isRefreshing: false,
        isOffline: false,
        lastSync: DateTime.now(),
      );
    } catch (_) {
      state = state.copyWith(
        isRefreshing: false,
        isOffline: true,
        errorMessage: 'Refresh failed. Cached data is still available.',
      );
    }
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setRegionFilter(String value) {
    state = state.copyWith(regionFilter: value);
  }

  void setCategoryFilter(String value) {
    state = state.copyWith(categoryFilter: value);
  }

  void setSortMode(PlaceSortMode value) {
    state = state.copyWith(sortMode: value);
  }

  void toggleFavoritesOnly(bool value) {
    state = state.copyWith(favoritesOnly: value);
  }

  Future<void> toggleFavorite(String placeId) async {
    final updated = {...state.favorites};
    if (updated.contains(placeId)) {
      updated.remove(placeId);
    } else {
      updated.add(placeId);
    }
    state = state.copyWith(favorites: updated);
    await _repository.saveFavorites(updated);
    await _repository.recordEvent(
      'Favorite updated',
      updated.contains(placeId)
          ? 'Added $placeId to favorites.'
          : 'Removed $placeId from favorites.',
      category: 'favorites',
    );
  }

  Future<void> clearCache() async {
    await _repository.clearCache();
    state = state.copyWith(allPlaces: const [], clearError: true);
  }

  TravelPlace? placeById(String id) {
    for (final place in state.allPlaces) {
      if (place.id == id) {
        return place;
      }
    }
    return null;
  }
}

class AppSettingsController extends StateNotifier<AppSettings> {
  AppSettingsController({
    required TravelRepository repository,
  })  : _repository = repository,
        super(AppSettings.defaults()) {
    unawaited(loadInitial());
  }

  final TravelRepository _repository;

  Future<void> loadInitial() async {
    state = await _repository.loadSettings();
  }

  Future<void> setThemePreference(AppThemePreference preference) async {
    state = state.copyWith(themePreference: preference);
    await _repository.saveSettings(state);
    await _repository.recordEvent(
      'Theme preference changed',
      'Theme preference set to ${preference.name}.',
      category: 'settings',
    );
  }

  Future<void> setPreviewMode(AppPreviewMode mode) async {
    state = state.copyWith(previewMode: mode);
    await _repository.saveSettings(state);
    await _repository.recordEvent(
      'Preview mode changed',
      'Preview mode set to ${mode.name}.',
      category: 'settings',
    );
  }

  Future<void> setShowMapPreview(bool value) async {
    state = state.copyWith(showMapPreview: value);
    await _repository.saveSettings(state);
  }

  Future<void> setCompactCards(bool value) async {
    state = state.copyWith(compactCards: value);
    await _repository.saveSettings(state);
  }

  Future<void> setEnableNotifications(bool value) async {
    state = state.copyWith(enableNotifications: value);
    await _repository.saveSettings(state);
  }
}

final appSettingsControllerProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>((ref) {
  final controller = AppSettingsController(
    repository: ref.watch(travelRepositoryProvider),
  );
  return controller;
});

final travelFeedControllerProvider =
    StateNotifierProvider<TravelFeedController, TravelFeedState>((ref) {
  final controller = TravelFeedController(
    repository: ref.watch(travelRepositoryProvider),
    settingsController: ref.read(appSettingsControllerProvider.notifier),
  );
  ref.listen<AppSettings>(appSettingsControllerProvider, (previous, next) {
    if (previous?.previewMode != next.previewMode) {
      unawaited(controller.loadInitial());
    }
  });
  return controller;
});

final auditEventsProvider = FutureProvider<List<AuditEvent>>((ref) async {
  return ref.watch(travelRepositoryProvider).loadAuditEvents();
});

final placeByIdProvider =
    FutureProvider.family.autoDispose<TravelPlace?, String>((ref, id) async {
  final feedState = ref.watch(travelFeedControllerProvider);
  final inMemory = feedState.allPlaces.where((place) => place.id == id);
  if (inMemory.isNotEmpty) {
    return inMemory.first;
  }
  return ref.watch(travelRepositoryProvider).findPlaceById(id);
});

final weatherProvider = FutureProvider.family
    .autoDispose<TravelWeather, String>((ref, placeId) async {
  final repository = ref.watch(travelRepositoryProvider);
  final place = await ref.watch(placeByIdProvider(placeId).future);
  if (place == null) {
    throw Exception('Place not found');
  }
  return repository.fetchWeather(place);
});
