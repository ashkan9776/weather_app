// lib/features/weather/presentation/bloc/weather_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/weather_forecast.dart'; // ⬅️ این import مهمه

abstract class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final bool isFromCache;

  WeatherLoaded({required this.weather, this.isFromCache = false});

  @override
  List<Object?> get props => [weather, isFromCache];
}

class ForecastLoaded extends WeatherState {
  // ⬅️ این state باید وجود داشته باشه
  final WeatherForecast forecast;
  final bool isFromCache;

  ForecastLoaded({required this.forecast, this.isFromCache = false});

  @override
  List<Object?> get props => [forecast, isFromCache];
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({required this.message});

  @override
  List<Object?> get props => [message];
}
