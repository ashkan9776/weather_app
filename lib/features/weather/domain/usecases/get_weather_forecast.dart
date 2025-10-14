// lib/features/weather/domain/usecases/get_weather_forecast.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather_forecast.dart';
import '../repositories/weather_repository.dart';

class GetWeatherForecast implements UseCase<WeatherForecast, ForecastParams> {
  final WeatherRepository repository;

  GetWeatherForecast(this.repository);

  @override
  Future<Either<Failure, WeatherForecast>> call(ForecastParams params) async {
    if (params.cityName.trim().isEmpty) {
      return Left(ValidationFailure());
    }

    return await repository.getWeatherForecast(params.cityName);
  }
}

class ForecastParams {
  final String cityName;

  ForecastParams({required this.cityName});
}
