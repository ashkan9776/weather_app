// lib/features/weather/domain/repositories/weather_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';
import '../entities/weather_forecast.dart';

abstract class WeatherRepository {
  /// دریافت آب و هوای فعلی
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName);

  /// دریافت پیش‌بینی ۵ روزه
  Future<Either<Failure, WeatherForecast>> getWeatherForecast(String cityName);
}
