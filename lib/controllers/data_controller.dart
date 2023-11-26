import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../utilities/snackbar.dart';
import '../model/weather_data.dart';

class DataController extends GetxController {
  WeatherData? todayWeather;
  WeatherData? selectedWeather;
  RxBool isWeatherSelected = false.obs;
  bool fetchFromSelection = false;
  List<WeatherData> theNext3DaysWeatherList = [];
  double latitude = 33;
  double longtude = 44;
  double? currentLatitude;
  double? currentLongitude;
  RxString backgroundImage = ''.obs;

  getBackgroundImage(String cityName) async {
    final res = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?query=paris&count=1&client_id=wW7pcYmq5ZEgMBlPyyeYn_HDj9XCqIKTbOQZatFJZC0'));
    final data = jsonDecode(res.body);
    if (data.runtimeType == List) {
      backgroundImage.value = data[0]['urls']['regular'];
    }
  }

  Future<void> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    latitude = locationData.latitude!.toPrecision(1);
    longtude = locationData.longitude!.toPrecision(1);
  }

  Future<bool> isWeatherFetched() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet ||
          connectivityResult == ConnectivityResult.vpn) {
        final res = await http.get(Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longtude&appid=d0eee6ea38d3912ec41e341c7fa10b05&cnt=4'));

        Map data = jsonDecode(res.body);

        if (fetchFromSelection == true) {
          selectedWeather = WeatherData(
            updatedTime: DateTime.now(),
            id: data['list'][0]['weather'][0]['id'],
            specLocation: data['city']['name'],
            counry: data['city']['country'],
            main: data['list'][0]['weather'][0]['main'],
            icon: data['list'][0]['weather'][0]['icon'],
            temp: data['list'][0]['main']['temp'],
            feelsLike: data['list'][0]['main']['feels_like'],
            humidity: data['list'][0]['main']['humidity'],
            windSpeed: data['list'][0]['wind']['speed'],
          );
          isWeatherSelected.value = true;
        } else {
          todayWeather = WeatherData(
            updatedTime: DateTime.now(),
            id: data['list'][0]['weather'][0]['id'],
            specLocation: data['city']['name'],
            counry: data['city']['country'],
            main: data['list'][0]['weather'][0]['main'],
            icon: data['list'][0]['weather'][0]['icon'],
            temp: data['list'][0]['main']['temp'],
            feelsLike: data['list'][0]['main']['feels_like'],
            humidity: data['list'][0]['main']['humidity'],
            windSpeed: data['list'][0]['wind']['speed'],
          );
        }
        for (int i = 1; i <= 3; i++) {
          WeatherData weather = WeatherData(
            updatedTime: DateTime.now(),
            id: data['list'][i]['weather'][0]['id'],
            specLocation: data['city']['name'],
            counry: data['city']['country'],
            main: data['list'][i]['weather'][0]['main'],
            icon: data['list'][i]['weather'][0]['icon'],
            temp: data['list'][i]['main']['temp'],
            feelsLike: data['list'][i]['main']['feels_like'],
            humidity: data['list'][i]['main']['humidity'],
            windSpeed: data['list'][i]['wind']['speed'],
          );
          theNext3DaysWeatherList.add(weather);
        }
      } else {
        showSnackbar('No Internet', 'Pls, Connect to Internet and Try Again!');
      }

      if (todayWeather != null) {
        return true;
      }
    } catch (error) {
      showSnackbar('Error', error.toString());
    }
    return false;
  }

  String getMonth(int month) {
    DateTime now = DateTime.now();
    String abbreviatedMonth = DateFormat('MMM').format(now);
    return abbreviatedMonth;
  }

  double toCelsius(double kelvin) {
    return (kelvin - 273.15).toPrecision(1);
  }

  String getWeek(int dayOfWeek) {
    DateTime dateTime = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday - dayOfWeek));
    String dayAbbreviation = DateFormat('EEE').format(dateTime);

    return dayAbbreviation;
  }
}
