// lib/features/weather/presentation/bloc/weather_event.dart
import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// دریافت آب و هوای فعلی
class GetWeatherForCity extends WeatherEvent {
  final String cityName;

  GetWeatherForCity({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}

/// دریافت پیش‌بینی ۵ روزه
class GetForecastForCity extends WeatherEvent {
  final String cityName;

  GetForecastForCity({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}

/// ریست کردن state
class ResetWeather extends WeatherEvent {}
