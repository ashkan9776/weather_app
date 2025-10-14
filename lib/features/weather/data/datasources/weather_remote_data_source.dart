// lib/features/weather/data/datasources/weather_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';
import '../models/weather_forecast_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(String cityName);
  Future<WeatherForecastModel> getWeatherForecast(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/weather?q=$cityName&appid=${ApiConstants.apiKey}',
    );

    print('🌐 درخواست آب و هوای فعلی: $url');

    try {
      final response = await client.get(url);

      print('📡 کد پاسخ: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ داده دریافت شد: ${jsonData['name']}');
        return WeatherModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        print('❌ شهر پیدا نشد');
        throw CityNotFoundException();
      } else if (response.statusCode == 401) {
        print('❌ API Key نامعتبر است');
        throw ServerException();
      } else {
        print('❌ خطای سرور: ${response.statusCode}');
        throw ServerException();
      }
    } catch (e) {
      print('❌ خطای شبکه: $e');
      if (e is ServerException || e is CityNotFoundException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  @override
  Future<WeatherForecastModel> getWeatherForecast(String cityName) async {
    // API برای پیش‌بینی ۵ روزه
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/forecast?q=$cityName&appid=${ApiConstants.apiKey}',
    );

    print('🌐 درخواست پیش‌بینی ۵ روزه: $url');

    try {
      final response = await client.get(url);

      print('📡 کد پاسخ: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ پیش‌بینی دریافت شد: ${jsonData['city']['name']}');
        return WeatherForecastModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        print('❌ شهر پیدا نشد');
        throw CityNotFoundException();
      } else if (response.statusCode == 401) {
        print('❌ API Key نامعتبر است');
        throw ServerException();
      } else {
        print('❌ خطای سرور: ${response.statusCode}');
        throw ServerException();
      }
    } catch (e) {
      print('❌ خطای شبکه: $e');
      if (e is ServerException || e is CityNotFoundException) {
        rethrow;
      }
      throw NetworkException();
    }
  }
}
