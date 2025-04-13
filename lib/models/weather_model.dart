class WeatherModel {
  final double temperature;
  final double windspeed;

  WeatherModel({
    required this.temperature,
    required this.windspeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['current_WeatherModel']['temperature']?.toDouble() ?? 0.0,
      windspeed: json['current_WeatherModel']['windspeed']?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'Temperatura: ${temperature.toStringAsFixed(1)}°C, Vento: ${windspeed.toStringAsFixed(1)} km/h';
  }
}
