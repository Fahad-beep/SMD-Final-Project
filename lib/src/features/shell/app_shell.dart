import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/settings.dart';
import '../../core/state/app_providers.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final wideLayout = MediaQuery.sizeOf(context).width >= 1000;
    final selectedIndex = _indexForLocation(location);
    final title = _titleForLocation(location);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(
              'Smart Travel Companion',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Appearance',
        onPressed: () => _showAppearanceSheet(context, ref, settings),
        child: const Icon(Icons.palette_rounded),
      ),
      bottomNavigationBar: wideLayout
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              destinations: _destinations
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon ?? item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
              onDestinationSelected: (index) {
                context.go(_destinations[index].path);
              },
            ),
      body: wideLayout
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  labelType: NavigationRailLabelType.all,
                  destinations: _destinations
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon ?? item.icon),
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                  onDestinationSelected: (index) {
                    context.go(_destinations[index].path);
                  },
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: child,
            ),
    );
  }

  static int _indexForLocation(String location) {
    if (location.startsWith('/favorites')) {
      return 1;
    }
    if (location.startsWith('/settings')) {
      return 2;
    }
    return 0;
  }

  static String _titleForLocation(String location) {
    if (location.startsWith('/favorites')) {
      return 'My Favorites';
    }
    if (location.startsWith('/settings')) {
      return 'Settings';
    }
    return 'Explore Places';
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.path,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final String path;
  final IconData icon;
  final IconData? selectedIcon;
}

const _destinations = [
  _NavItem(
    label: 'Explore',
    path: '/',
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore_rounded,
  ),
  _NavItem(
    label: 'Favorites',
    path: '/favorites',
    icon: Icons.favorite_border_rounded,
    selectedIcon: Icons.favorite_rounded,
  ),
  _NavItem(
    label: 'Settings',
    path: '/settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
  ),
];

Future<void> _showAppearanceSheet(
  BuildContext context,
  WidgetRef ref,
  AppSettings settings,
) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose the look that feels best on your device.',
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ...AppThemePreference.values.map(
                (value) => Card(
                  child: RadioListTile<AppThemePreference>(
                    value: value,
                    groupValue: settings.themePreference,
                    onChanged: (selected) async {
                      if (selected != null) {
                        await ref
                            .read(appSettingsControllerProvider.notifier)
                            .setThemePreference(selected);
                        if (context.mounted) {
                          Navigator.of(sheetContext).pop();
                        }
                      }
                    },
                    title: Text(_themeLabel(value)),
                    subtitle: Text(_themeDescription(value)),
                    secondary: Icon(_themeIcon(value)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
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
    AppThemePreference.system => 'Follows your phone settings automatically.',
    AppThemePreference.light => 'Bright cards and clean contrast for daytime use.',
    AppThemePreference.dark => 'Deep colors with softer highlights for low-light use.',
  };
}

IconData _themeIcon(AppThemePreference preference) {
  return switch (preference) {
    AppThemePreference.system => Icons.brightness_auto_rounded,
    AppThemePreference.light => Icons.light_mode_rounded,
    AppThemePreference.dark => Icons.dark_mode_rounded,
  };
}
