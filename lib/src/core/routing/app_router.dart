import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/detail/detail_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/app_shell.dart';
import '../models/place.dart';

class AppRouteNames {
  static const home = 'home';
  static const favorites = 'favorites';
  static const settings = 'settings';
  static const placeDetail = 'placeDetail';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: AppRouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/favorites',
            name: AppRouteNames.favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: AppRouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/place/:id',
        name: AppRouteNames.placeDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final initialPlace =
              state.extra is TravelPlace ? state.extra as TravelPlace : null;
          return PlaceDetailScreen(
            placeId: id,
            initialPlace: initialPlace,
          );
        },
      ),
    ],
  );
});
