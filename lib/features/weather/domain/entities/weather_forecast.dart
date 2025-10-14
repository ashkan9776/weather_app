// lib/features/weather/domain/entities/weather_forecast.dart
import 'package:equatable/equatable.dart';

/// پیش‌بینی یک روز خاص
class DailyWeather extends Equatable {
  final DateTime date;
  final double tempMax; // بیشترین دما
  final double tempMin; // کمترین دما
  final String condition; // وضعیت آسمان
  final int humidity;
  final double windSpeed;
  final String description; // توضیحات (مثلا: light rain)

  const DailyWeather({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.description,
  });

  @override
  List<Object?> get props => [
    date,
    tempMax,
    tempMin,
    condition,
    humidity,
    windSpeed,
    description,
  ];
}

/// پیش‌بینی کامل یک شهر (۵ روز)
class WeatherForecast extends Equatable {
  final String cityName;
  final List<DailyWeather> dailyForecasts; // لیست ۵ روزه

  const WeatherForecast({required this.cityName, required this.dailyForecasts});

  @override
  List<Object?> get props => [cityName, dailyForecasts];
}
