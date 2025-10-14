// lib/features/weather/presentation/widgets/weather_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final bool isFromCache;

  const WeatherCard({Key? key, required this.weather, this.isFromCache = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // نام شهر
            Text(
              weather.cityName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // آیکون آب و هوا
            Icon(_getWeatherIcon(), size: 100, color: Colors.white),
            const SizedBox(height: 16),

            // دما
            Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // وضعیت
            Text(
              _translateCondition(weather.condition),
              style: const TextStyle(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 24),

            // جزئیات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetail(Icons.water_drop, 'رطوبت', '${weather.humidity}%'),
                _buildDetail(
                  Icons.air,
                  'باد',
                  '${weather.windSpeed.toStringAsFixed(1)} km/h',
                ),
              ],
            ),

            // نشانگر کش
            if (isFromCache)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.offline_bolt, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text('آفلاین', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  LinearGradient _getGradient() {
    switch (weather.condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'rain':
        return const LinearGradient(
          colors: [Colors.blue, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Colors.teal, Colors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getWeatherIcon() {
    switch (weather.condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.water_drop;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  String _translateCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'آفتابی';
      case 'clouds':
        return 'ابری';
      case 'rain':
        return 'بارانی';
      case 'snow':
        return 'برفی';
      default:
        return condition;
    }
  }
}
