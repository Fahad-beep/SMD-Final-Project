import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/state/app_providers.dart';
import '../../core/models/settings.dart';

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
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: () async {
              final current = settings.themePreference;
              final next = switch (current) {
                AppThemePreference.system => AppThemePreference.dark,
                AppThemePreference.dark => AppThemePreference.light,
                AppThemePreference.light => AppThemePreference.system,
              };
              await ref
                  .read(appSettingsControllerProvider.notifier)
                  .setThemePreference(next);
            },
            icon: Icon(
              switch (settings.themePreference) {
                AppThemePreference.system => Icons.brightness_auto_rounded,
                AppThemePreference.light => Icons.light_mode_rounded,
                AppThemePreference.dark => Icons.dark_mode_rounded,
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: wideLayout ? null : _AppDrawer(currentIndex: selectedIndex),
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
    if (location.startsWith('/admin')) {
      return 2;
    }
    if (location.startsWith('/settings')) {
      return 3;
    }
    return 0;
  }

  static String _titleForLocation(String location) {
    if (location.startsWith('/favorites')) {
      return 'My Favorites';
    }
    if (location.startsWith('/admin')) {
      return 'Admin Studio';
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
    label: 'Admin',
    path: '/admin',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard_rounded,
  ),
  _NavItem(
    label: 'Settings',
    path: '/settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
  ),
];

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.flight_takeoff_rounded),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Smart Travel Companion',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Travel planning, testing, and offline support in one place.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ...List.generate(_destinations.length, (index) {
              final item = _destinations[index];
              return ListTile(
                selected: index == currentIndex,
                leading: Icon(index == currentIndex
                    ? item.selectedIcon ?? item.icon
                    : item.icon),
                title: Text(item.label),
                onTap: () {
                  Navigator.pop(context);
                  context.go(item.path);
                },
              );
            }),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview mode',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<AppPreviewMode>(
                    value: settings.previewMode,
                    items: AppPreviewMode.values
                        .map(
                          (mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(mode.name),
                          ),
                        )
                        .toList(),
                    onChanged: (mode) {
                      if (mode != null) {
                        ref
                            .read(appSettingsControllerProvider.notifier)
                            .setPreviewMode(mode);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
