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
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'App Preferences',
                    subtitle: 'Control theme, preview mode, and UI details.',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AppThemePreference>(
                    value: settings.themePreference,
                    decoration: const InputDecoration(labelText: 'Theme'),
                    items: AppThemePreference.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        settingsController.setThemePreference(value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<AppPreviewMode>(
                    value: settings.previewMode,
                    decoration:
                        const InputDecoration(labelText: 'Preview mode'),
                    items: AppPreviewMode.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        settingsController.setPreviewMode(value);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.showMapPreview,
                    title: const Text('Show map preview'),
                    subtitle:
                        const Text('Display map-related UI on detail pages.'),
                    onChanged: settingsController.setShowMapPreview,
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.compactCards,
                    title: const Text('Compact cards'),
                    subtitle: const Text(
                        'Show a tighter list layout on smaller screens.'),
                    onChanged: settingsController.setCompactCards,
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: settings.enableNotifications,
                    title: const Text('Enable reminders'),
                    subtitle:
                        const Text('Keep the in-app reminder tools active.'),
                    onChanged: settingsController.setEnableNotifications,
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
                    title: 'Data controls',
                    subtitle:
                        'Keep the cache healthy and rebuild the feed when needed.',
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
                        label: const Text('Reload feed'),
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
                  const SizedBox(height: 16),
                  Text(
                    'The preview mode in the drawer can force live, empty, offline, or error states for demonstration and testing.',
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
