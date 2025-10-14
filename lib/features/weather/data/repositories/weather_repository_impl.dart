// lib/features/weather/data/repositories/weather_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/weather_forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_data_source.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName) async {
    print('🔍 شروع جستجوی آب و هوای فعلی برای: $cityName');

    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      print('🌐 اینترنت متصل است - درخواست از API');

      try {
        final remoteWeather = await remoteDataSource.getCurrentWeather(
          cityName,
        );
        await localDataSource.cacheWeather(remoteWeather);
        print('✅ داده از API دریافت و در کش ذخیره شد');
        return Right(remoteWeather);
      } on ServerException {
        print('❌ خطای سرور');
        return Left(ServerFailure(message: 'خطا در ارتباط با سرور'));
      } on CityNotFoundException {
        print('❌ شهر پیدا نشد');
        return Left(CityNotFoundFailure(message: 'شهر "$cityName" پیدا نشد'));
      } on NetworkException {
        print('❌ خطای شبکه');
        return Left(
          NetworkFailure(message: 'لطفا اتصال اینترنت را بررسی کنید'),
        );
      }
    } else {
      print('📴 اینترنت قطع است - تلاش برای خواندن از کش');

      try {
        final localWeather = await localDataSource.getCachedWeather();
        print('✅ داده از کش خوانده شد');
        return Right(localWeather);
      } on CacheException {
        print('❌ کش خالی است');
        return Left(
          CacheFailure(
            message: 'داده‌ای در حافظه موجود نیست. لطفا اینترنت را وصل کنید',
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, WeatherForecast>> getWeatherForecast(
    String cityName,
  ) async {
    print('🔍 شروع جستجوی پیش‌بینی برای: $cityName');

    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      print('🌐 اینترنت متصل است - درخواست پیش‌بینی از API');

      try {
        final remoteForecast = await remoteDataSource.getWeatherForecast(
          cityName,
        );
        await localDataSource.cacheForecast(remoteForecast);
        print('✅ پیش‌بینی از API دریافت و در کش ذخیره شد');
        return Right(remoteForecast);
      } on ServerException {
        print('❌ خطای سرور');
        return Left(ServerFailure(message: 'خطا در ارتباط با سرور'));
      } on CityNotFoundException {
        print('❌ شهر پیدا نشد');
        return Left(CityNotFoundFailure(message: 'شهر "$cityName" پیدا نشد'));
      } on NetworkException {
        print('❌ خطای شبکه');
        return Left(
          NetworkFailure(message: 'لطفا اتصال اینترنت را بررسی کنید'),
        );
      }
    } else {
      print('📴 اینترنت قطع است - تلاش برای خواندن پیش‌بینی از کش');

      try {
        final localForecast = await localDataSource.getCachedForecast();
        print('✅ پیش‌بینی از کش خوانده شد');
        return Right(localForecast);
      } on CacheException {
        print('❌ کش پیش‌بینی خالی است');
        return Left(
          CacheFailure(
            message: 'داده‌ای در حافظه موجود نیست. لطفا اینترنت را وصل کنید',
          ),
        );
      }
    }
  }
}
