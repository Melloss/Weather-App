import 'dart:math' show pi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/utilities/snackbar.dart';

import '../controllers/data_controller.dart';
import '../utilities/color_pallet.dart';
import '../utilities/media_query.dart';

class WeatherList extends StatefulWidget {
  const WeatherList({super.key});

  @override
  State<WeatherList> createState() => _WeatherListState();
}

class _WeatherListState extends State<WeatherList> with ColorPallet {
  DataController db = Get.find();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: screenWidth(context),
        height: screenHeight(context),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation(192 / pi),
            colors: [
              Color(0xFF391A49),
              Color(0xFF301D5C),
              Color(0xFF262171),
              Color(0xFF301D5C),
              Color(0xFF391A49),
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                _buildTop(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildWeatherCard(
                          city: db.todayWeather!.specLocation,
                          weatherType: db.todayWeather!.main,
                          humidity: db.todayWeather!.humidity,
                          wind: db.todayWeather!.windSpeed,
                          icon: db.todayWeather!.icon,
                          temp: db.toCelsius(db.todayWeather!.temp),
                          latitude: db.currentLatitude == null
                              ? db.latitude
                              : db.currentLatitude!,
                          longitude: db.currentLongitude == null
                              ? db.longtude
                              : db.currentLongitude!,
                        ),
                        _buildWeatherCard(
                          city: 'New York',
                          weatherType: 'Sunny',
                          humidity: 52,
                          wind: 115,
                          icon: '04d',
                          temp: 33,
                          latitude: 20,
                          longitude: 30,
                        ),
                        _buildAddNewButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isLoading,
              child: const Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTop() {
    return Container(
      height: screenHeight(context) * 0.17,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: const Alignment(0, -0.1),
            child: Text(
              'Saved Location',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/search_icon.png',
            ),
          )
        ],
      ),
    );
  }

  _buildWeatherCard({
    required String city,
    required String weatherType,
    required int humidity,
    required double wind,
    required String icon,
    required double temp,
    required double latitude,
    required double longitude,
  }) {
    return InkWell(
      onTap: () async {
        if (db.currentLatitude == null && db.currentLongitude == null) {
          db.currentLatitude = latitude;
          db.currentLongitude = longitude;
        }
        print(db.currentLatitude);
        db.latitude = latitude;
        db.longtude = longitude;
        db.fetchFromSelection = true;
        setState(() {
          isLoading = true;
        });

        final isFetched = await db.isWeatherFetched();
        setState(() {
          isLoading = false;
        });
        if (isFetched == true) {
          Get.to(() => const HomeScreen());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        width: screenWidth(context) * 0.95,
        decoration: BoxDecoration(
          color: weatherCardBackgoundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 30,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    weatherType,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: 'Humidity ',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                      children: [
                        TextSpan(
                          text: '$humidity%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      text: 'Wind ',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                      children: [
                        TextSpan(
                          text: '$wind km/h',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                CachedNetworkImage(
                  imageUrl: 'http://openweathermap.org/img/wn/$icon@2x.png',
                  width: 70,
                  height: 70,
                ),
                Text('$tempºC', style: Theme.of(context).textTheme.displayLarge)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildAddNewButton() {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 10, bottom: 30),
      width: screenWidth(context) * 0.95,
      decoration: BoxDecoration(
        color: weatherCardBackgoundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_circle_outline),
          const SizedBox(width: 8),
          Text(
            'Add new',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 25,
                ),
          )
        ],
      ),
    );
  }
}
