// lib/features/weather/presentation/widgets/forecast_list.dart
import 'package:flutter/material.dart';
import '../../domain/entities/weather_forecast.dart';
import 'forecast_card.dart';

class ForecastList extends StatelessWidget {
  final WeatherForecast forecast;
  final bool isFromCache;

  const ForecastList({
    Key? key,
    required this.forecast,
    this.isFromCache = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان شهر
          Row(
            children: [
              Icon(Icons.location_city, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                forecast.cityName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const Spacer(),
              if (isFromCache)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        size: 16,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'آفلاین',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'پیش‌بینی ۵ روز آینده',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // لیست روزها
          Expanded(
            child: ListView.builder(
              itemCount: forecast.dailyForecasts.length,
              itemBuilder: (context, index) {
                final daily = forecast.dailyForecasts[index];
                return ForecastCard(dailyWeather: daily, isToday: index == 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
