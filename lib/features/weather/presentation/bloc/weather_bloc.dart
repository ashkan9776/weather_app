import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_current_weather.dart';
import 'weather_event.dart';
import 'weather_state.dart';

/// BLoC: Business Logic Component
/// واسط بین UI و Domain
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;

  WeatherBloc({required this.getCurrentWeather}) : super(WeatherInitial()) {
    // ثبت handler برای هر event
    on<GetWeatherForCity>(_onGetWeatherForCity);
    on<ResetWeather>(_onResetWeather);
  }

  /// وقتی event دریافت آب و هوا میاد
  Future<void> _onGetWeatherForCity(
    GetWeatherForCity event,
    Emitter<WeatherState> emit,
  ) async {
    print('🎯 BLoC: رویداد دریافت آب و هوا برای ${event.cityName}');

    // نمایش لودینگ
    emit(WeatherLoading());

    // فراخوانی UseCase
    final result = await getCurrentWeather(
      WeatherParams(cityName: event.cityName),
    );

    // پردازش نتیجه (Either)
    result.fold(
      // Left = خطا
      (failure) {
        print('❌ BLoC: خطا دریافت شد');
        emit(WeatherError(message: _mapFailureToMessage(failure)));
      },
      // Right = موفق
      (weather) {
        print('✅ BLoC: داده دریافت شد - ${weather.cityName}');

        // چک کنیم آیا از کش اومده؟
        final isFromCache = Failure is CacheFailure;

        emit(WeatherLoaded(weather: weather, isFromCache: isFromCache));
      },
    );
  }

  /// ریست کردن state
  void _onResetWeather(ResetWeather event, Emitter<WeatherState> emit) {
    print('🔄 BLoC: ریست state');
    emit(WeatherInitial());
  }

  /// تبدیل Failure به پیام کاربرپسند
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
