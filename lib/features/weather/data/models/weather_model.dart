import '../../domain/entities/weather.dart';

/// Model: نسخه‌ای از Entity که میتونه به JSON تبدیل بشه
/// از Entity ارث‌بری میکنه
class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.condition,
    required super.humidity,
    required super.windSpeed,
  });

  /// تبدیل JSON به Model
  /// این متد داده‌ای که از API میاد رو تبدیل میکنه
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] as String,
      // دمای Kelvin به Celsius تبدیل میشه
      temperature: (json['main']['temp'] as num).toDouble() - 273.15,
      condition: json['weather'][0]['main'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }

  /// تبدیل Model به JSON
  /// برای ذخیره در کش یا ارسال به سرور
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature + 273.15, // برگشت به Kelvin
        'humidity': humidity,
      },
      'weather': [
        {'main': condition}
      ],
      'wind': {'speed': windSpeed},
    };
  }

  /// تبدیل Model به Entity
  Weather toEntity() {
    return Weather(
      cityName: cityName,
      temperature: temperature,
      condition: condition,
      humidity: humidity,
      windSpeed: windSpeed,
    );
  }
}