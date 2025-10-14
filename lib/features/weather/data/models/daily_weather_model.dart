// lib/features/weather/data/models/daily_weather_model.dart
import '../../domain/entities/weather_forecast.dart';

class DailyWeatherModel extends DailyWeather {
  const DailyWeatherModel({
    required super.date,
    required super.tempMax,
    required super.tempMin,
    required super.condition,
    required super.humidity,
    required super.windSpeed,
    required super.description,
  });

  factory DailyWeatherModel.fromJson(Map<String, dynamic> json) {
    return DailyWeatherModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: (json['main']['temp_max'] as num).toDouble() - 273.15,
      tempMin: (json['main']['temp_min'] as num).toDouble() - 273.15,
      condition: json['weather'][0]['main'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': date.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp_max': tempMax + 273.15,
        'temp_min': tempMin + 273.15,
        'humidity': humidity,
      },
      'weather': [
        {
          'main': condition,
          'description': description,
        }
      ],
      'wind': {'speed': windSpeed},
    };
  }
}