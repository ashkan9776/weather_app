// lib/features/weather/data/models/weather_forecast_model.dart
import '../../domain/entities/weather_forecast.dart';
import 'daily_weather_model.dart';

class WeatherForecastModel extends WeatherForecast {
  const WeatherForecastModel({
    required super.cityName,
    required super.dailyForecasts,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];

    // گروه‌بندی بر اساس روز
    final Map<String, List<DailyWeatherModel>> groupedByDay = {};

    for (var item in list) {
      final model = DailyWeatherModel.fromJson(item);
      final dateKey =
          '${model.date.year}-${model.date.month}-${model.date.day}';

      if (!groupedByDay.containsKey(dateKey)) {
        groupedByDay[dateKey] = [];
      }
      groupedByDay[dateKey]!.add(model);
    }

    // محاسبه میانگین برای هر روز
    final List<DailyWeather> dailyForecasts = groupedByDay.entries.map((entry) {
      final dayWeathers = entry.value;

      // پیدا کردن بیشترین و کمترین دما
      double maxTemp = dayWeathers
          .map((w) => w.tempMax)
          .reduce((a, b) => a > b ? a : b);
      double minTemp = dayWeathers
          .map((w) => w.tempMin)
          .reduce((a, b) => a < b ? a : b);

      // میانگین رطوبت و سرعت باد
      int avgHumidity =
          (dayWeathers.map((w) => w.humidity).reduce((a, b) => a + b) /
                  dayWeathers.length)
              .round();
      double avgWindSpeed =
          dayWeathers.map((w) => w.windSpeed).reduce((a, b) => a + b) /
          dayWeathers.length;

      // شایع‌ترین وضعیت آب و هوا
      final conditionCounts = <String, int>{};
      for (var w in dayWeathers) {
        conditionCounts[w.condition] = (conditionCounts[w.condition] ?? 0) + 1;
      }
      final mostCommonCondition = conditionCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      return DailyWeather(
        date: dayWeathers.first.date,
        tempMax: maxTemp,
        tempMin: minTemp,
        condition: mostCommonCondition,
        humidity: avgHumidity,
        windSpeed: avgWindSpeed,
        description: dayWeathers.first.description,
      );
    }).toList();

    // فقط ۵ روز اول
    final limitedForecasts = dailyForecasts.take(5).toList();

    return WeatherForecastModel(
      cityName: json['city']['name'],
      dailyForecasts: limitedForecasts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': {'name': cityName},
      'list': dailyForecasts
          .map(
            (daily) => DailyWeatherModel(
              date: daily.date,
              tempMax: daily.tempMax,
              tempMin: daily.tempMin,
              condition: daily.condition,
              humidity: daily.humidity,
              windSpeed: daily.windSpeed,
              description: daily.description,
            ).toJson(),
          )
          .toList(),
    };
  }
}
