// lib/features/weather/presentation/widgets/forecast_card.dart
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../domain/entities/weather_forecast.dart';

class ForecastCard extends StatelessWidget {
  final DailyWeather dailyWeather;
  final bool isToday;

  const ForecastCard({
    Key? key,
    required this.dailyWeather,
    this.isToday = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isToday ? 8 : 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isToday
            ? BorderSide(color: Colors.blue.shade300, width: 2)
            : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isToday
              ? LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // تاریخ و روز
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(dailyWeather.date),
                    style: TextStyle(
                      fontSize: isToday ? 18 : 16,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      color: isToday ? Colors.blue.shade900 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getWeekDay(dailyWeather.date),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'امروز',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // آیکون آب و هوا
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Icon(
                    _getWeatherIcon(dailyWeather.condition),
                    size: isToday ? 60 : 50,
                    color: _getWeatherColor(dailyWeather.condition),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _translateCondition(dailyWeather.condition),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // دما
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${dailyWeather.tempMax.toStringAsFixed(0)}°',
                            style: TextStyle(
                              fontSize: isToday ? 28 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade400,
                            ),
                          ),
                          Text(
                            '${dailyWeather.tempMin.toStringAsFixed(0)}°',
                            style: TextStyle(
                              fontSize: isToday ? 20 : 18,
                              color: Colors.blue.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildDetailChip(
                        Icons.water_drop,
                        '${dailyWeather.humidity}%',
                      ),
                      const SizedBox(width: 8),
                      _buildDetailChip(
                        Icons.air,
                        '${dailyWeather.windSpeed.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // ⬅️ تاریخ شمسی فارسی
  String _formatDate(DateTime date) {
    final jalali = Jalali.fromDateTime(date);
    final formatter = jalali.formatter;
    return '${formatter.d} ${formatter.mN}';
  }

  String _getWeekDay(DateTime date) {
    final jalali = Jalali.fromDateTime(date);
    return jalali.formatter.wN;
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.water_drop;
      case 'drizzle':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.thunderstorm;
      default:
        return Icons.wb_cloudy;
    }
  }

  Color _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Colors.orange.shade400;
      case 'clouds':
        return Colors.grey.shade500;
      case 'rain':
      case 'drizzle':
        return Colors.blue.shade600;
      case 'snow':
        return Colors.lightBlue.shade200;
      case 'thunderstorm':
        return Colors.deepPurple.shade400;
      default:
        return Colors.blueGrey.shade400;
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
      case 'drizzle':
        return 'نم‌نم باران';
      case 'snow':
        return 'برفی';
      case 'thunderstorm':
        return 'رعد و برق';
      default:
        return condition;
    }
  }
}
