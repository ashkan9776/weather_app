// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/weather/presentation/bloc/weather_bloc.dart';
import 'features/weather/presentation/pages/weather_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // راه‌اندازی DI
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir', // فونت فارسی
      ),
      home: BlocProvider(
        // ساخت BLoC با DI
        create: (_) => di.sl<WeatherBloc>(),
        child: const WeatherPage(),
      ),
    );
  }
}
