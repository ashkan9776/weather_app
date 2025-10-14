// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/weather/data/datasources/weather_local_data_source.dart';
import 'features/weather/data/datasources/weather_remote_data_source.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/get_current_weather.dart';
import 'features/weather/domain/usecases/get_weather_forecast.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  print('🚀 شروع راه‌اندازی Dependency Injection...');

  //! Features - Weather

  // Bloc
  sl.registerFactory(
    () => WeatherBloc(
      getCurrentWeather: sl(),
      getWeatherForecast: sl(), // اضافه شد
    ),
  );
  print('✅ WeatherBloc ثبت شد');

  // Use cases
  sl.registerLazySingleton(() => GetCurrentWeather(sl()));
  sl.registerLazySingleton(() => GetWeatherForecast(sl())); // اضافه شد
  print('✅ UseCases ثبت شدند');

  // Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  print('✅ WeatherRepository ثبت شد');

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(client: sl()),
  );
  print('✅ WeatherRemoteDataSource ثبت شد');

  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(sharedPreferences: sl()),
  );
  print('✅ WeatherLocalDataSource ثبت شد');

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  print('✅ NetworkInfo ثبت شد');

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  print('✅ SharedPreferences ثبت شد');

  sl.registerLazySingleton(() => http.Client());
  print('✅ HTTP Client ثبت شد');

  sl.registerLazySingleton(() => InternetConnection());
  print('✅ InternetConnection ثبت شد');

  print('🎉 Dependency Injection با موفقیت راه‌اندازی شد!');
}
