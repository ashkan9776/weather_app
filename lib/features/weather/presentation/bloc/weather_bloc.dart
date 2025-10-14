// lib/features/weather/presentation/bloc/weather_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_weather_forecast.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetWeatherForecast getWeatherForecast;

  WeatherBloc({
    required this.getCurrentWeather,
    required this.getWeatherForecast,
  }) : super(WeatherInitial()) {
    on<GetWeatherForCity>(_onGetWeatherForCity);
    on<GetForecastForCity>(_onGetForecastForCity);
    on<ResetWeather>(_onResetWeather);
  }

  Future<void> _onGetWeatherForCity(
    GetWeatherForCity event,
    Emitter<WeatherState> emit,
  ) async {
    print('🎯 BLoC: رویداد دریافت آب و هوا برای ${event.cityName}');

    emit(WeatherLoading());

    final result = await getCurrentWeather(
      WeatherParams(cityName: event.cityName),
    );

    result.fold(
      (failure) {
        print('❌ BLoC: خطا دریافت شد');
        emit(WeatherError(message: _mapFailureToMessage(failure)));
      },
      (weather) {
        print('✅ BLoC: داده دریافت شد - ${weather.cityName}');
        emit(WeatherLoaded(weather: weather));
      },
    );
  }

  Future<void> _onGetForecastForCity(
    GetForecastForCity event,
    Emitter<WeatherState> emit,
  ) async {
    print('🎯 BLoC: رویداد دریافت پیش‌بینی برای ${event.cityName}');

    emit(WeatherLoading());

    final result = await getWeatherForecast(
      ForecastParams(cityName: event.cityName),
    );

    result.fold(
      (failure) {
        print('❌ BLoC: خطا دریافت شد');
        emit(WeatherError(message: _mapFailureToMessage(failure)));
      },
      (forecast) {
        print('✅ BLoC: پیش‌بینی دریافت شد - ${forecast.cityName}');
        emit(ForecastLoaded(forecast: forecast));
      },
    );
  }

  void _onResetWeather(ResetWeather event, Emitter<WeatherState> emit) {
    print('🔄 BLoC: ریست state');
    emit(WeatherInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'خطای سرور';
    } else if (failure is CacheFailure) {
      return failure.message ?? 'داده‌ای در حافظه موجود نیست';
    } else if (failure is NetworkFailure) {
      return failure.message ?? 'لطفا اتصال اینترنت را بررسی کنید';
    } else if (failure is CityNotFoundFailure) {
      return failure.message ?? 'شهر پیدا نشد';
    } else if (failure is ValidationFailure) {
      return 'نام شهر را وارد کنید';
    }
    return 'خطای نامشخص';
  }
}
