// lib/features/weather/presentation/pages/weather_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/city_input.dart';
import '../widgets/forecast_list.dart'; // ⬅️ این خط رو اضافه کن

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('هواشناسی'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<WeatherBloc>().add(ResetWeather());
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CityInput(
                onSubmit: (cityName) {
                  context.read<WeatherBloc>().add(
                    GetForecastForCity(cityName: cityName),
                  );
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherInitial) {
                      return _buildInitialWidget();
                    } else if (state is WeatherLoading) {
                      return _buildLoadingWidget();
                    } else if (state is ForecastLoaded) {
                      return ForecastList(
                        forecast: state.forecast,
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
      ),
    );
  }

  Widget _buildInitialWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wb_sunny, size: 100, color: Colors.orange.shade400),
          const SizedBox(height: 16),
          const Text(
            'نام شهر را وارد کنید',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'پیش‌بینی ۵ روز آینده را مشاهده کنید',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
