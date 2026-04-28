class WeatherForecast {
  const WeatherForecast({
    required this.date,
    required this.minTemperature,
    required this.maxTemperature,
    required this.weatherCode,
  });

  final DateTime date;
  final double minTemperature;
  final double maxTemperature;
  final int weatherCode;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date'] as String),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
      weatherCode: json['weatherCode'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'weatherCode': weatherCode,
    };
  }
}

class TravelWeather {
  const TravelWeather({
    required this.placeId,
    required this.temperature,
    required this.feelsLike,
    required this.windSpeed,
    required this.humidity,
    required this.weatherCode,
    required this.summary,
    required this.updatedAt,
    required this.forecast,
  });

  final String placeId;
  final double temperature;
  final double feelsLike;
  final double windSpeed;
  final int humidity;
  final int weatherCode;
  final String summary;
  final DateTime updatedAt;
  final List<WeatherForecast> forecast;

  factory TravelWeather.fromJson(Map<String, dynamic> json) {
    return TravelWeather(
      placeId: json['placeId'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      humidity: json['humidity'] as int,
      weatherCode: json['weatherCode'] as int,
      summary: json['summary'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      forecast: (json['forecast'] as List<dynamic>)
          .map((entry) =>
              WeatherForecast.fromJson(entry as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'weatherCode': weatherCode,
      'summary': summary,
      'updatedAt': updatedAt.toIso8601String(),
      'forecast': forecast.map((entry) => entry.toJson()).toList(),
    };
  }
}
