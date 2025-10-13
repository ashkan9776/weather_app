// lib/features/weather/presentation/pages/weather_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/weather_card.dart';
import '../widgets/city_input.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('هواشناسی'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ریست کردن
              context.read<WeatherBloc>().add(ResetWeather());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ورودی نام شهر
            CityInput(
              onSubmit: (cityName) {
                // ارسال event
                context.read<WeatherBloc>().add(
                      GetWeatherForCity(cityName: cityName),
                    );
              },
            ),
            const SizedBox(height: 32),
            
            // نمایش بر اساس state
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return _buildInitialWidget();
                  } else if (state is WeatherLoading) {
                    return _buildLoadingWidget();
                  } else if (state is WeatherLoaded) {
                    return WeatherCard(
                      weather: state.weather,
                      isFromCache: state.isFromCache,
                    );
                  } else if (state is WeatherError) {
                    return _buildErrorWidget(state.message);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'نام شهر را وارد کنید',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('در حال دریافت اطلاعات...'),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 100, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ],
      ),
    );
  }
}