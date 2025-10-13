import 'package:equatable/equatable.dart';

/// رویدادهایی که UI میتونه ارسال کنه
abstract class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// رویداد: دریافت آب و هوای یک شهر
class GetWeatherForCity extends WeatherEvent {
  final String cityName;

  GetWeatherForCity({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}

/// رویداد: ریست کردن state
class ResetWeather extends WeatherEvent {}