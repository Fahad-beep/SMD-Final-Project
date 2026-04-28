import 'package:flutter/material.dart';

class WeatherCodeInfo {
  const WeatherCodeInfo({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

WeatherCodeInfo weatherCodeInfo(int code) {
  switch (code) {
    case 0:
      return const WeatherCodeInfo(
        label: 'Clear sky',
        icon: Icons.wb_sunny_rounded,
      );
    case 1:
    case 2:
      return const WeatherCodeInfo(
        label: 'Partly cloudy',
        icon: Icons.wb_cloudy_rounded,
      );
    case 3:
      return const WeatherCodeInfo(
        label: 'Cloudy',
        icon: Icons.cloud_rounded,
      );
    case 45:
    case 48:
      return const WeatherCodeInfo(
        label: 'Fog',
        icon: Icons.blur_on_rounded,
      );
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return const WeatherCodeInfo(
        label: 'Drizzle',
        icon: Icons.grain_rounded,
      );
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return const WeatherCodeInfo(
        label: 'Rain',
        icon: Icons.water_drop_rounded,
      );
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return const WeatherCodeInfo(
        label: 'Snow',
        icon: Icons.ac_unit_rounded,
      );
    case 95:
    case 96:
    case 99:
      return const WeatherCodeInfo(
        label: 'Storm',
        icon: Icons.flash_on_rounded,
      );
    default:
      return const WeatherCodeInfo(
        label: 'Mixed weather',
        icon: Icons.cloud_queue_rounded,
      );
  }
}
