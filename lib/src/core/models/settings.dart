import 'package:flutter/material.dart';

enum AppThemePreference { system, light, dark }

extension AppThemePreferenceX on AppThemePreference {
  ThemeMode toThemeMode() {
    return switch (this) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };
  }

  static AppThemePreference fromString(String value) {
    return AppThemePreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => AppThemePreference.system,
    );
  }
}

class AppSettings {
  const AppSettings({
    required this.themePreference,
  });

  final AppThemePreference themePreference;

  factory AppSettings.defaults() {
    return const AppSettings(
      themePreference: AppThemePreference.system,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themePreference: AppThemePreferenceX.fromString(
        json['themePreference'] as String? ?? AppThemePreference.system.name,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themePreference': themePreference.name,
    };
  }

  AppSettings copyWith({
    AppThemePreference? themePreference,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
    );
  }
}
