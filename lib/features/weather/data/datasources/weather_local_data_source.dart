import 'dart:convert';
import 'package:flutter_application_1/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

/// Interface برای Local Data Source
abstract class WeatherLocalDataSource {
  /// دریافت آخرین آب و هوای ذخیره شده
  Future<WeatherModel> getLastWeather();

  /// ذخیره آب و هوا در کش
  Future<void> cacheWeather(WeatherModel weather);
}

/// پیاده‌سازی Local Data Source
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  // کلید ذخیره‌سازی
  static const String cachedWeatherKey = 'CACHED_WEATHER';

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<WeatherModel> getLastWeather() async {
    // خواندن از SharedPreferences
    final jsonString = sharedPreferences.getString(cachedWeatherKey);

    if (jsonString != null) {
      print('💾 داده از کش خوانده شد');
      // تبدیل String به JSON و سپس به Model
      return WeatherModel.fromJson(json.decode(jsonString));
    } else {
      print('❌ کش خالی است');
      throw CacheException();
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel weather) async {
    // تبدیل Model به JSON و سپس به String
    final jsonString = json.encode(weather.toJson());

    // ذخیره در SharedPreferences
    await sharedPreferences.setString(cachedWeatherKey, jsonString);
    print('✅ داده در کش ذخیره شد: ${weather.cityName}');
  }
}
