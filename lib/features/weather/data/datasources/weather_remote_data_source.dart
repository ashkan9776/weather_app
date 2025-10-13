// lib/features/weather/data/datasources/weather_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';

/// Interface برای Remote Data Source
abstract class WeatherRemoteDataSource {
  /// دریافت آب و هوا از API
  Future<WeatherModel> getCurrentWeather(String cityName);
}

/// پیاده‌سازی Remote Data Source
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName) async {
    // ساخت URL
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/weather?q=$cityName&appid=${ApiConstants.apiKey}',
    );

    print('🌐 درخواست به API: $url');

    try {
      // ارسال درخواست HTTP
      final response = await client.get(url);

      print('📡 کد پاسخ: ${response.statusCode}');

      if (response.statusCode == 200) {
        // موفق - تبدیل JSON به Model
        final jsonData = json.decode(response.body);
        print('✅ داده دریافت شد: ${jsonData['name']}');
        return WeatherModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        // شهر پیدا نشد
        print('❌ شهر پیدا نشد');
        throw CityNotFoundException();
      } else {
        // خطای سرور
        print('❌ خطای سرور: ${response.statusCode}');
        throw ServerException();
      }
    } catch (e) {
      // خطای شبکه (مثلاً اینترنت قطع است)
      print('❌ خطای شبکه: $e');
      if (e is ServerException || e is CityNotFoundException) {
        rethrow;
      }
      throw NetworkException();
    }
  }
}
