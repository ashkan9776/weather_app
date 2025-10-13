// lib/features/weather/data/repositories/weather_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_data_source.dart';
import '../datasources/weather_remote_data_source.dart';

/// پیاده‌سازی واقعی Repository
/// این کلاس تصمیم میگیره از Remote یا Local استفاده کنه
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
    print('🔍 شروع جستجوی آب و هوا برای: $cityName');

    // چک کردن اتصال اینترنت
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      print('🌐 اینترنت متصل است - درخواست از API');

      try {
        // دریافت از Remote
        final remoteWeather = await remoteDataSource.getCurrentWeather(
          cityName,
        );

        // ذخیره در کش برای استفاده آفلاین
        await localDataSource.cacheWeather(remoteWeather);

        print('✅ داده از API دریافت و در کش ذخیره شد');

        // برگشت موفقیت (Right)
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
        // دریافت از Local (کش)
        final localWeather = await localDataSource.getLastWeather();

        print('✅ داده از کش خوانده شد');

        // برگشت موفقیت (Right)
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
  Future<Either<Failure, List<Weather>>> getWeatherForecast(
    String cityName,
  ) async {
    // برای سادگی پیاده‌سازی نشده
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Weather>>> getWeatherForest(String cityName) {
    // TODO: implement getWeatherForest
    throw UnimplementedError();
  }
}
