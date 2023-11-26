import 'dart:convert';

import 'package:fast_csv/csv_converter.dart';
import 'package:flutter/services.dart';
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
  List<WeatherData> defaultWeatherList = [];
  List<WeatherData> addedWeatherList = [];
  double latitude = 33;
  double longtude = 44;
  double? currentLatitude;
  double? currentLongitude;
  RxString backgroundImage = ''.obs;
  final cities = {
    'New York': {
      'latitude': 40.7128,
      'longitude': -74.0060,
    },
    'Paris': {
      'latitude': 48.8566,
      'longitude': 2.3522,
    },
  };

  Future<void> fetchWeatherUsingCoordinate(
      {required double longitude, required double latitude}) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet ||
          connectivityResult == ConnectivityResult.vpn) {
        final res = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=d0eee6ea38d3912ec41e341c7fa10b05'));
        Map data = jsonDecode(res.body);

        final weather = WeatherData(
          updatedTime: DateTime.now(),
          id: data['weather'][0]['id'],
          specLocation: data['name'],
          main: data['weather'][0]['main'],
          icon: data['weather'][0]['icon'],
          temp: data['main']['temp'],
          feelsLike: data['main']['feels_like'],
          humidity: data['main']['humidity'],
          windSpeed: data['wind']['speed'],
          longitude: longitude,
          latitude: latitude,
        );
        addedWeatherList.add(weather);
      } else {
        showSnackbar('No Internet', 'Pls, Connect to Internet and Try Again!');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<List<List<dynamic>>> readFromCsv() async {
    final csvString = await rootBundle.loadString('assets/country_capital.csv');
    final csvTable = CsvConverter().convert(csvString);
    csvTable.removeAt(0);
    return csvTable;
  }

  fetchDefaultWeathers() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet ||
          connectivityResult == ConnectivityResult.vpn) {
        cities.forEach((key, value) async {
          final res = await http.get(Uri.parse(
              'https://api.openweathermap.org/data/2.5/weather?lat=${value['latitude']}&lon=${value['longitude']}&appid=d0eee6ea38d3912ec41e341c7fa10b05'));
          Map data = jsonDecode(res.body);
          final weather = WeatherData(
            updatedTime: DateTime.now(),
            id: data['weather'][0]['id'],
            specLocation: data['name'],
            main: data['weather'][0]['main'],
            icon: data['weather'][0]['icon'],
            temp: data['main']['temp'],
            feelsLike: data['main']['feels_like'],
            humidity: data['main']['humidity'],
            windSpeed: data['wind']['speed'],
          );
          defaultWeatherList.add(weather);
        });
      }
    } catch (error) {
      defaultWeatherList.clear();
    }
  }

  Future<void> getBackgroundImage(String cityName) async {
    try {
      final res = await http.get(Uri.parse(
          'https://api.unsplash.com/photos/random?query=$cityName&count=1&client_id=wW7pcYmq5ZEgMBlPyyeYn_HDj9XCqIKTbOQZatFJZC0'));
      final data = jsonDecode(res.body);
      if (data.runtimeType == List) {
        backgroundImage.value = data[0]['urls']['regular'];
      } else {
        backgroundImage.value = '';
      }
    } catch (error) {
      backgroundImage.value = '';
    }
  }

  Future<void> getLocationPermission() async {
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
            main: data['list'][0]['weather'][0]['main'],
            icon: data['list'][0]['weather'][0]['icon'],
            temp: data['list'][0]['main']['temp'],
            feelsLike: data['list'][0]['main']['feels_like'],
            humidity: data['list'][0]['main']['humidity'],
            windSpeed: data['list'][0]['wind']['speed'],
          );
          currentLatitude = latitude;
          currentLongitude = longtude;
        }
        for (int i = 1; i <= 3; i++) {
          WeatherData weather = WeatherData(
            updatedTime: DateTime.now(),
            id: data['list'][i]['weather'][0]['id'],
            specLocation: data['city']['name'],
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
      print(error.toString());
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
