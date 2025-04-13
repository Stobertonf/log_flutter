import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:log_flutter/core/models/weather_model.dart';

class WeatherApiService {
  static Future<WeatherModel?> buscarClima(
      {double latitude = -23.55, double longitude = -46.63}) async {
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
