import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

/// UseCase: یه کار مشخص کسب‌وکار
/// هر UseCase فقط یک کار انجام میده (Single Responsibility)
class GetCurrentWeather implements UseCase<Weather, WeatherParams> {
  final WeatherRepository repository;

  GetCurrentWeather(this.repository);

  @override
  Future<Either<Failure, Weather>> call(WeatherParams params) async {
    // اینجا میتونیم منطق اضافی بزاریم
    // مثلاً validation، logging، و غیره

    // اگه نام شهر خالی باشه
    if (params.cityName.trim().isEmpty) {
      return Left(ValidationFailure());
    }

    // درخواست از repository
    return await repository.getCurrentWeather(params.cityName);
  }
}

/// پارامترهای ورودی UseCase
class WeatherParams {
  final String cityName;

  WeatherParams({required this.cityName});
}
