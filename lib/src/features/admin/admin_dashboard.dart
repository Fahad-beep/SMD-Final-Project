import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/settings.dart';
import '../../core/state/app_providers.dart';
import '../widgets/common_widgets.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(travelFeedControllerProvider);
    final settings = ref.watch(appSettingsControllerProvider);
    final repository = ref.read(travelRepositoryProvider);
    final auditAsync = ref.watch(auditEventsProvider);
    final settingsController = ref.read(appSettingsControllerProvider.notifier);
    final feedController = ref.read(travelFeedControllerProvider.notifier);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Admin Studio',
                    subtitle:
                        'Use this panel to test the app, inspect cache health, and switch preview states.',
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      MetricCard(
                        label: 'Loaded places',
                        value: '${feedState.allPlaces.length}',
                        icon: Icons.travel_explore_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      MetricCard(
                        label: 'Favorites',
                        value: '${feedState.favorites.length}',
                        icon: Icons.favorite_rounded,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      MetricCard(
                        label: 'Theme',
                        value: settings.themePreference.name,
                        icon: Icons.palette_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      MetricCard(
                        label: 'Preview',
                        value: settings.previewMode.name,
                        icon: Icons.science_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'QA lab',
                    subtitle:
                        'Force the main app into different demonstration states.',
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: AppPreviewMode.values
                        .map(
                          (mode) => ChoiceChip(
                            label: Text(mode.name),
                            selected: settings.previewMode == mode,
                            onSelected: (_) {
                              settingsController.setPreviewMode(mode);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () => feedController.loadInitial(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reload feed'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => feedController.clearCache(),
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Clear cache'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await repository.recordEvent(
                            'Admin note created',
                            'A manual note was added from the admin panel.',
                            category: 'admin',
                          );
                          ref.invalidate(auditEventsProvider);
                        },
                        icon: const Icon(Icons.note_add_rounded),
                        label: const Text('Add note'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Recent activity',
                    subtitle:
                        'Syncs, settings changes, and manual admin actions.',
                  ),
                  const SizedBox(height: 16),
                  auditAsync.when(
                    data: (events) {
                      if (events.isEmpty) {
                        return const EmptyStateView(
                          icon: Icons.receipt_long_rounded,
                          title: 'No events yet',
                          subtitle:
                              'The dashboard will populate as you refresh, favorite, or change preview mode.',
                        );
                      }
                      return Column(
                        children: events
                            .map(
                              (event) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  child: const Icon(Icons.bolt_rounded),
                                ),
                                title: Text(event.title),
                                subtitle: Text(
                                  '${event.details}\n${DateFormat.yMMMd().add_jm().format(event.createdAt)}',
                                ),
                                isThreeLine: true,
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => ErrorStateView(
                      title: 'Could not load logs',
                      subtitle: error.toString(),
                      onRetry: () => ref.invalidate(auditEventsProvider),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
