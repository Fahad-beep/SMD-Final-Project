import 'package:flutter/material.dart';

enum AppThemePreference { system, light, dark }

enum AppPreviewMode { live, empty, offline, error }

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

extension AppPreviewModeX on AppPreviewMode {
  static AppPreviewMode fromString(String value) {
    return AppPreviewMode.values.firstWhere(
      (item) => item.name == value,
      orElse: () => AppPreviewMode.live,
    );
  }
}

class AppSettings {
  const AppSettings({
    required this.themePreference,
    required this.previewMode,
    required this.showMapPreview,
    required this.compactCards,
    required this.enableNotifications,
  });

  final AppThemePreference themePreference;
  final AppPreviewMode previewMode;
  final bool showMapPreview;
  final bool compactCards;
  final bool enableNotifications;

  factory AppSettings.defaults() {
    return const AppSettings(
      themePreference: AppThemePreference.system,
      previewMode: AppPreviewMode.live,
      showMapPreview: true,
      compactCards: false,
      enableNotifications: true,
    );
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themePreference: AppThemePreferenceX.fromString(
        json['themePreference'] as String? ?? AppThemePreference.system.name,
      ),
      previewMode: AppPreviewModeX.fromString(
        json['previewMode'] as String? ?? AppPreviewMode.live.name,
      ),
      showMapPreview: json['showMapPreview'] as bool? ?? true,
      compactCards: json['compactCards'] as bool? ?? false,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themePreference': themePreference.name,
      'previewMode': previewMode.name,
      'showMapPreview': showMapPreview,
      'compactCards': compactCards,
      'enableNotifications': enableNotifications,
    };
  }

  AppSettings copyWith({
    AppThemePreference? themePreference,
    AppPreviewMode? previewMode,
    bool? showMapPreview,
    bool? compactCards,
    bool? enableNotifications,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      previewMode: previewMode ?? this.previewMode,
      showMapPreview: showMapPreview ?? this.showMapPreview,
      compactCards: compactCards ?? this.compactCards,
      enableNotifications: enableNotifications ?? this.enableNotifications,
    );
  }
}
