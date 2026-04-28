import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/state/app_providers.dart';
import 'core/models/settings.dart';
import 'core/theme/app_theme.dart';

class SmartTravelApp extends ConsumerWidget {
  const SmartTravelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider);
    return MaterialApp.router(
      title: 'Smart Travel Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themePreference.toThemeMode(),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
