// lib/features/weather/data/datasources/weather_local_data_source.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';
import '../models/weather_forecast_model.dart';

abstract class WeatherLocalDataSource {
  Future<WeatherModel> getCachedWeather();
  Future<void> cacheWeather(WeatherModel weather);
  Future<WeatherForecastModel> getCachedForecast();
  Future<void> cacheForecast(WeatherForecastModel forecast);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cachedWeatherKey = 'CACHED_WEATHER';
  static const String cachedForecastKey = 'CACHED_FORECAST';

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<WeatherModel> getCachedWeather() async {
    final jsonString = sharedPreferences.getString(cachedWeatherKey);

    if (jsonString != null) {
      print('💾 آب و هوای فعلی از کش خوانده شد');
      return WeatherModel.fromJson(json.decode(jsonString));
    } else {
      print('❌ کش خالی است');
      throw CacheException();
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel weather) async {
    final jsonString = json.encode(weather.toJson());
    await sharedPreferences.setString(cachedWeatherKey, jsonString);
    print('✅ آب و هوای فعلی در کش ذخیره شد: ${weather.cityName}');
  }

  @override
  Future<WeatherForecastModel> getCachedForecast() async {
    final jsonString = sharedPreferences.getString(cachedForecastKey);

    if (jsonString != null) {
      print('💾 پیش‌بینی از کش خوانده شد');
      return WeatherForecastModel.fromJson(json.decode(jsonString));
    } else {
      print('❌ کش پیش‌بینی خالی است');
      throw CacheException();
    }
  }

  @override
  Future<void> cacheForecast(WeatherForecastModel forecast) async {
    final jsonString = json.encode(forecast.toJson());
    await sharedPreferences.setString(cachedForecastKey, jsonString);
    print('✅ پیش‌بینی در کش ذخیره شد: ${forecast.cityName}');
  }
}
