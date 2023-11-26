class WeatherData {
  final int id;
  final String specLocation;
  final String counry;
  final String main;
  final String icon;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final DateTime updatedTime;
  const WeatherData({
    required this.id,
    required this.specLocation,
    required this.counry,
    required this.main,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.updatedTime,
  });
}
