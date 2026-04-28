import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_router.dart';
import '../../core/state/app_providers.dart';
import '../home/widgets/animated_place_list.dart';
import '../widgets/common_widgets.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(travelFeedControllerProvider);
    final controller = ref.read(travelFeedControllerProvider.notifier);
    final favoritePlaces = state.allPlaces
        .where((place) => state.favorites.contains(place.id))
        .toList();

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'My Favorites',
                      subtitle: 'A saved shortlist for quick planning.',
                      action: TextButton.icon(
                        onPressed: favoritePlaces.isEmpty
                            ? null
                            : () async {
                                for (final place in favoritePlaces) {
                                  await controller.toggleFavorite(place.id);
                                }
                              },
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Clear all'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${favoritePlaces.length} places saved',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          if (favoritePlaces.isEmpty)
            const SliverToBoxAdapter(
              child: EmptyStateView(
                icon: Icons.favorite_border_rounded,
                title: 'No favorites yet',
                subtitle:
                    'Tap the heart on any travel card to build a personal shortlist.',
              ),
            )
          else
            AnimatedPlaceList(
              places: favoritePlaces,
              favoriteIds: state.favorites,
              onPlaceTap: (place) {
                context.pushNamed(
                  AppRouteNames.placeDetail,
                  pathParameters: {'id': place.id},
                  extra: place,
                );
              },
              onFavoriteToggle: (place) async {
                await controller.toggleFavorite(place.id);
              },
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
