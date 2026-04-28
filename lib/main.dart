import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/data/hive_travel_store.dart';
import 'src/core/state/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await HiveTravelStore.open();
  runApp(
    ProviderScope(
      overrides: [
        travelStoreProvider.overrideWithValue(store),
      ],
      child: const SmartTravelApp(),
    ),
  );
}
