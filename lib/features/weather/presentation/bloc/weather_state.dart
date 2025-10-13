import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';

/// وضعیت‌های مختلف UI
abstract class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// وضعیت اولیه - هنوز هیچ کاری نشده
class WeatherInitial extends WeatherState {}

/// در حال لود کردن
class WeatherLoading extends WeatherState {}

/// داده با موفقیت لود شد
class WeatherLoaded extends WeatherState {
  final Weather weather;
  final bool isFromCache; // آیا از کش خوانده شده؟

  WeatherLoaded({
    required this.weather,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [weather, isFromCache];
}

/// خطا رخ داده
class WeatherError extends WeatherState {
  final String message;

  WeatherError({required this.message});

  @override
  List<Object?> get props => [message];
}