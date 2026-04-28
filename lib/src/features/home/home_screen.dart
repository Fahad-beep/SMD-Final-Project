import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/routing/app_router.dart';
import '../../core/state/app_providers.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/place_filters.dart';
import '../widgets/common_widgets.dart';
import 'widgets/animated_place_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _searchController;
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(travelFeedControllerProvider);
    final controller = ref.read(travelFeedControllerProvider.notifier);
    final places = state.visiblePlaces;
    final regions =
        state.allPlaces.map((place) => place.region).toSet().toList()..sort();
    final categories =
        state.allPlaces.map((place) => place.category).toSet().toList()..sort();
    final compact = MediaQuery.sizeOf(context).width < 720;

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _HeaderCard(
              totalPlaces: state.allPlaces.length,
              visiblePlaces: places.length,
              favoriteCount: state.favorites.length,
              lastSync: state.lastSync,
              isRefreshing: state.isRefreshing,
              onRefresh: controller.refresh,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          if (state.isOffline || state.errorMessage != null)
            SliverToBoxAdapter(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StatusBanner(
                    message: state.errorMessage ??
                        'You are working from cached data right now.',
                    icon: state.isOffline
                        ? Icons.cloud_off_rounded
                        : Icons.info_outline_rounded,
                    color: state.isOffline
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: _SearchAndFiltersCard(
              searchController: _searchController,
              query: state.searchQuery,
              regions: regions,
              categories: categories,
              regionFilter: state.regionFilter,
              categoryFilter: state.categoryFilter,
              favoritesOnly: state.favoritesOnly,
              sortMode: state.sortMode,
              onSearchChanged: (value) {
                _debouncer(() => controller.setSearchQuery(value));
              },
              onClearFilters: () {
                _searchController.clear();
                controller
                  ..setSearchQuery('')
                  ..setRegionFilter('')
                  ..setCategoryFilter('')
                  ..toggleFavoritesOnly(false);
              },
              onRegionChanged: controller.setRegionFilter,
              onCategoryChanged: controller.setCategoryFilter,
              onFavoritesOnlyChanged: controller.toggleFavoritesOnly,
              onSortChanged: controller.setSortMode,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          if (state.isLoading && state.allPlaces.isEmpty)
            const SliverToBoxAdapter(
              child: _LoadingStateView(),
            )
          else if (state.errorMessage != null && state.allPlaces.isEmpty)
            SliverToBoxAdapter(
              child: ErrorStateView(
                title: 'We could not load places',
                subtitle: state.errorMessage!,
                onRetry: controller.loadInitial,
              ),
            )
          else if (places.isEmpty)
            const SliverToBoxAdapter(
              child: EmptyStateView(
                icon: Icons.travel_explore_rounded,
                title: 'No places found',
                subtitle:
                    'Try a different search term, clear the filters, or pull to refresh.',
              ),
            )
          else
            AnimatedPlaceList(
              places: places,
              favoriteIds: state.favorites,
              compact: compact,
              onPlaceTap: (place) {
                context.pushNamed(
                  AppRouteNames.placeDetail,
                  pathParameters: {'id': place.id},
                  extra: place,
                );
              },
              onFavoriteToggle: (place) => controller.toggleFavorite(place.id),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.totalPlaces,
    required this.visiblePlaces,
    required this.favoriteCount,
    required this.lastSync,
    required this.isRefreshing,
    required this.onRefresh,
  });

  final int totalPlaces;
  final int visiblePlaces;
  final int favoriteCount;
  final DateTime? lastSync;
  final bool isRefreshing;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final scheme = Theme.of(context).colorScheme;
    final lastSyncLabel = lastSync == null
        ? 'Waiting for the first sync'
        : 'Synced ${DateFormat.Hm().format(lastSync!)}';

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: isRefreshing ? 0.82 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primary.withOpacity(0.95),
              scheme.secondary.withOpacity(0.9),
              scheme.tertiary.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan better, travel lighter.',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Live place data, weather details, offline cache, and polished travel browsing.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              height: 1.35,
                            ),
                      ),
                    ],
                  ),
                ),
                if (isWide)
                  FilledButton.tonalIcon(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Refresh'),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MiniStat(
                  label: 'Places',
                  value: '$totalPlaces',
                  icon: Icons.public_rounded,
                ),
                _MiniStat(
                  label: 'Visible',
                  value: '$visiblePlaces',
                  icon: Icons.tune_rounded,
                ),
                _MiniStat(
                  label: 'Favorites',
                  value: '$favoriteCount',
                  icon: Icons.favorite_rounded,
                ),
                _MiniStat(
                  label: 'Status',
                  value: lastSyncLabel,
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndFiltersCard extends StatelessWidget {
  const _SearchAndFiltersCard({
    required this.searchController,
    required this.query,
    required this.regions,
    required this.categories,
    required this.regionFilter,
    required this.categoryFilter,
    required this.favoritesOnly,
    required this.sortMode,
    required this.onSearchChanged,
    required this.onClearFilters,
    required this.onRegionChanged,
    required this.onCategoryChanged,
    required this.onFavoritesOnlyChanged,
    required this.onSortChanged,
  });

  final TextEditingController searchController;
  final String query;
  final List<String> regions;
  final List<String> categories;
  final String regionFilter;
  final String categoryFilter;
  final bool favoritesOnly;
  final PlaceSortMode sortMode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearFilters;
  final ValueChanged<String> onRegionChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onFavoritesOnlyChanged;
  final ValueChanged<PlaceSortMode> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search places, countries, or categories',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<PlaceSortMode>(
                  value: sortMode,
                  decoration: const InputDecoration(labelText: 'Sort'),
                  items: PlaceSortMode.values
                      .map(
                        (mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(mode.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onSortChanged(value);
                    }
                  },
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  value: regionFilter.isEmpty ? null : regionFilter,
                  decoration: const InputDecoration(labelText: 'Region'),
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('All regions'),
                    ),
                    ...regions.map(
                      (region) => DropdownMenuItem(
                        value: region,
                        child: Text(region),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    onRegionChanged(value ?? '');
                  },
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  value: categoryFilter.isEmpty ? null : categoryFilter,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('All categories'),
                    ),
                    ...categories.map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    onCategoryChanged(value ?? '');
                  },
                ),
              ),
              FilterChip(
                label: const Text('Favorites only'),
                selected: favoritesOnly,
                onSelected: onFavoritesOnlyChanged,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            query.isEmpty
                ? 'Showing curated destinations'
                : 'Results for "$query"',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _LoadingStateView extends StatelessWidget {
  const _LoadingStateView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading travel stories...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
