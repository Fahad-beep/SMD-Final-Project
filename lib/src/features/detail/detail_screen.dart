import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/place.dart';
import '../../core/models/weather.dart';
import '../../core/state/app_providers.dart';
import '../../core/utils/weather_codes.dart';
import '../widgets/common_widgets.dart';

class PlaceDetailScreen extends ConsumerStatefulWidget {
  const PlaceDetailScreen({
    super.key,
    required this.placeId,
    this.initialPlace,
  });

  final String placeId;
  final TravelPlace? initialPlace;

  @override
  ConsumerState<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends ConsumerState<PlaceDetailScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final placeAsync = widget.initialPlace != null
        ? AsyncValue.data(widget.initialPlace)
        : ref.watch(placeByIdProvider(widget.placeId));

    return Scaffold(
      body: placeAsync.when(
        data: (place) {
          if (place == null) {
            return _buildLoading();
          }

          final weatherAsync = ref.watch(weatherProvider(widget.placeId));
          final favoriteIds = ref.watch(travelFeedControllerProvider).favorites;
          final controller = ref.read(travelFeedControllerProvider.notifier);
          final isFavorite = favoriteIds.contains(place.id);

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 920;
                final content = wide
                    ? Row(
                        children: [
                          Expanded(flex: 5, child: _HeroSection(place: place)),
                          Expanded(
                            flex: 6,
                            child: SizedBox(
                              height: constraints.maxHeight,
                              child: SingleChildScrollView(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 24, 20, 24),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: _DetailContent(
                                    place: place,
                                    weatherAsync: weatherAsync,
                                    isFavorite: isFavorite,
                                    isExpanded: _expanded,
                                    onToggleExpanded: () {
                                      setState(() => _expanded = !_expanded);
                                    },
                                    onFavoriteToggle: () =>
                                        controller.toggleFavorite(place.id),
                                    onOpenMaps: () => _openMaps(place),
                                    onRetryWeather: () =>
                                        ref.invalidate(weatherProvider(place.id)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(child: _HeroSection(place: place)),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 20, 16, 24),
                              child: _DetailContent(
                                place: place,
                                weatherAsync: weatherAsync,
                                isFavorite: isFavorite,
                                isExpanded: _expanded,
                                onToggleExpanded: () {
                                  setState(() => _expanded = !_expanded);
                                },
                                onFavoriteToggle: () =>
                                    controller.toggleFavorite(place.id),
                                onOpenMaps: () => _openMaps(place),
                                onRetryWeather: () =>
                                    ref.invalidate(weatherProvider(place.id)),
                              ),
                            ),
                          ),
                        ],
                      );
                return content;
              },
            ),
          );
        },
        loading: () => _buildLoading(),
        error: (error, stackTrace) => _buildError(context, error),
      ),
    );
  }

  Widget _buildLoading() {
    return const SafeArea(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ErrorStateView(
            title: 'Could not open the destination',
            subtitle: error.toString(),
            onRetry: () => ref.invalidate(placeByIdProvider(widget.placeId)),
          ),
        ),
      ),
    );
  }

  Future<void> _openMaps(TravelPlace place) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.place});

  final TravelPlace place;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).width >= 920 ? 620.0 : 340.0;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'place-image-${place.id}',
            child: TravelImageFrame(
              imageUrl: place.imageUrl,
              fallbackIcon: Icons.explore_rounded,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.12),
                  Colors.black.withOpacity(0.72),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(
                    place.region,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.16),
                  side: BorderSide.none,
                ),
                const SizedBox(height: 10),
                Text(
                  place.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${place.country} - ${place.category}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
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

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.place,
    required this.weatherAsync,
    required this.isFavorite,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onFavoriteToggle,
    required this.onOpenMaps,
    required this.onRetryWeather,
  });

  final TravelPlace place;
  final AsyncValue<TravelWeather> weatherAsync;
  final bool isFavorite;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onOpenMaps;
  final VoidCallback onRetryWeather;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                place.title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: onFavoriteToggle,
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _Tag(label: place.country, icon: Icons.flag_rounded),
            _Tag(label: place.category, icon: Icons.category_rounded),
            _Tag(label: place.region, icon: Icons.public_rounded),
            _Tag(
              label: '${place.rating.toStringAsFixed(1)} rating',
              icon: Icons.star_rounded,
            ),
          ],
        ),
        const SizedBox(height: 18),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: weatherAsync.when(
            data: (weather) {
              final info = weatherCodeInfo(weather.weatherCode);
              return _WeatherCard(
                weather: weather,
                icon: info.icon,
                label: info.label,
              );
            },
            loading: () => const _WeatherLoadingCard(),
            error: (error, stackTrace) => _WeatherErrorCard(
              message: error.toString(),
              onRetry: onRetryWeather,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'About this place',
                  subtitle: 'Tap to expand and read more.',
                  action: TextButton(
                    onPressed: onToggleExpanded,
                    child: Text(isExpanded ? 'Collapse' : 'Read more'),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: Text(
                    place.description,
                    maxLines: isExpanded ? null : 4,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Travel tools',
                  subtitle: 'Built in for maps and quick actions.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: onOpenMaps,
                      icon: const Icon(Icons.map_rounded),
                      label: const Text('Open in Maps'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_active_rounded),
                      label: const Text('Save reminder'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Coordinates: ${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({
    required this.weather,
    required this.icon,
    required this.label,
  });

  final TravelWeather weather;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Live weather',
              subtitle: 'Current conditions from Open-Meteo.',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.65),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, size: 34),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(0)}°',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Feels like ${weather.feelsLike.toStringAsFixed(0)}°'),
                    Text('${weather.windSpeed.toStringAsFixed(0)} km/h wind'),
                    Text('${weather.humidity}% humidity'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 88,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final day = weather.forecast[index];
                  final info = weatherCodeInfo(day.weatherCode);
                  return Container(
                    width: 118,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E().format(day.date),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 6),
                        Icon(info.icon, size: 18),
                        const SizedBox(height: 6),
                        Text(
                          '${day.maxTemperature.toStringAsFixed(0)}° / ${day.minTemperature.toStringAsFixed(0)}°',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: weather.forecast.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherLoadingCard extends StatelessWidget {
  const _WeatherLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 180,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(
                'Loading weather...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherErrorCard extends StatelessWidget {
  const _WeatherErrorCard({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: ErrorStateView(
          title: 'Weather unavailable',
          subtitle: message,
          onRetry: onRetry,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
    );
  }
}
