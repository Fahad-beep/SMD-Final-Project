import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/weather.dart';

class WeatherApiClient {
  WeatherApiClient(this._client);

  final http.Client _client;

  Future<TravelWeather> fetchWeather({
    required String placeId,
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      <String, String>{
        'latitude': '$latitude',
        'longitude': '$longitude',
        'current':
            'temperature_2m,apparent_temperature,wind_speed_10m,weather_code',
        'hourly': 'relative_humidity_2m',
        'daily': 'temperature_2m_max,temperature_2m_min,weather_code',
        'forecast_days': '3',
        'timezone': 'auto',
      },
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load weather');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final current = decoded['current'] as Map<String, dynamic>;
    final hourly = decoded['hourly'] as Map<String, dynamic>;
    final daily = decoded['daily'] as Map<String, dynamic>;

    final currentTime = current['time'] as String;
    final hourlyTimes = List<String>.from(hourly['time'] as List<dynamic>);
    final humidityValues =
        List<num>.from(hourly['relative_humidity_2m'] as List<dynamic>);
    final currentIndex = hourlyTimes.indexWhere(
      (time) => time.startsWith(currentTime.substring(0, 13)),
    );
    final humidity = currentIndex >= 0
        ? humidityValues[currentIndex].round()
        : humidityValues.isEmpty
            ? 0
            : humidityValues.first.round();

    final dailyDates = List<String>.from(daily['time'] as List<dynamic>);
    final dailyMax =
        List<num>.from(daily['temperature_2m_max'] as List<dynamic>);
    final dailyMin =
        List<num>.from(daily['temperature_2m_min'] as List<dynamic>);
    final dailyCodes = List<num>.from(daily['weather_code'] as List<dynamic>);

    final forecast = List.generate(
      dailyDates.length,
      (index) => WeatherForecast(
        date: DateTime.parse(dailyDates[index]),
        minTemperature: dailyMin[index].toDouble(),
        maxTemperature: dailyMax[index].toDouble(),
        weatherCode: dailyCodes[index].round(),
      ),
    );

    return TravelWeather(
      placeId: placeId,
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: current['apparent_temperature'] == null
          ? (current['temperature_2m'] as num).toDouble()
          : (current['apparent_temperature'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      humidity: humidity,
      weatherCode: (current['weather_code'] as num).round(),
      summary: 'Live weather',
      updatedAt: DateTime.now(),
      forecast: forecast,
    );
  }
}
