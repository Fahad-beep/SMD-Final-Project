import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/settings.dart';
import '../../core/state/app_providers.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider);
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
                    title: 'Appearance',
                    subtitle:
                        'A simple theme control for a polished client experience.',
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: AppThemePreference.values.map((value) {
                      final selected = settings.themePreference == value;
                      return ChoiceChip(
                        selected: selected,
                        label: Text(_themeLabel(value)),
                        avatar: Icon(
                          _themeIcon(value),
                          size: 18,
                          color: selected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onSelected: (_) {
                          settingsController.setThemePreference(value);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _themeDescription(settings.themePreference),
                    style: Theme.of(context).textTheme.bodyMedium,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Storage',
                    subtitle:
                        'Clear saved places if you want a fresh reload from the APIs.',
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () async {
                          await feedController.loadInitial();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reload places'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await feedController.clearCache();
                          await feedController.loadInitial();
                        },
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Clear cache'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'The app keeps previously loaded places on the device so it can still show content when the network is weak.',
                    style: Theme.of(context).textTheme.bodyMedium,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'About',
                    subtitle: 'Project details for the submission pack.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Smart Travel Companion is a responsive Flutter app for exploring travel destinations, checking weather, saving favorites, and testing a polished offline flow.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Data sources: jsonplaceholder.typicode.com/photos and api.open-meteo.com.',
                    style: Theme.of(context).textTheme.bodyMedium,
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

String _themeLabel(AppThemePreference preference) {
  return switch (preference) {
    AppThemePreference.system => 'System',
    AppThemePreference.light => 'Light',
    AppThemePreference.dark => 'Dark',
  };
}

String _themeDescription(AppThemePreference preference) {
  return switch (preference) {
    AppThemePreference.system => 'Matches your phone settings automatically.',
    AppThemePreference.light => 'Bright and clean for daytime use.',
    AppThemePreference.dark => 'Soft contrast for low-light use.',
  };
}

IconData _themeIcon(AppThemePreference preference) {
  return switch (preference) {
    AppThemePreference.system => Icons.brightness_auto_rounded,
    AppThemePreference.light => Icons.light_mode_rounded,
    AppThemePreference.dark => Icons.dark_mode_rounded,
  };
}
