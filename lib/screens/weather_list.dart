import 'dart:math' show pi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../screens/home_screen.dart';
import '../controllers/data_controller.dart';
import '../utilities/color_pallet.dart';
import '../utilities/media_query.dart';

class WeatherList extends StatefulWidget {
  const WeatherList({super.key});

  @override
  State<WeatherList> createState() => _WeatherListState();
}

class _WeatherListState extends State<WeatherList> with ColorPallet {
  DataController dc = Get.find();
  bool isLoading = false;
  bool showSearchBar = false;
  bool isAddButtonClicked = false;
  List citiesList = [];

  @override
  void initState() {
    dc.readFromCsv().then((value) {
      citiesList = value;
    });

    super.initState();
  }

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
                          city: dc.todayWeather!.specLocation,
                          weatherType: dc.todayWeather!.main,
                          humidity: dc.todayWeather!.humidity,
                          wind: dc.todayWeather!.windSpeed,
                          icon: dc.todayWeather!.icon,
                          temp: dc.todayWeather!.temp,
                          latitude: dc.currentLatitude == null
                              ? dc.latitude
                              : dc.currentLatitude!,
                          longitude: dc.currentLongitude == null
                              ? dc.longtude
                              : dc.currentLongitude!,
                        ),
                        _buildWeatherCard(
                          city: dc.defaultWeatherList[0].specLocation,
                          weatherType: dc.defaultWeatherList[0].main,
                          humidity: dc.defaultWeatherList[0].humidity,
                          wind: dc.defaultWeatherList[0].windSpeed,
                          icon: dc.defaultWeatherList[0].icon,
                          temp: dc.defaultWeatherList[0].temp,
                          latitude: dc.cities[dc.defaultWeatherList[0]
                                  .specLocation]!['latitude'] ??
                              0,
                          longitude: dc.cities[dc.defaultWeatherList[0]
                                  .specLocation]!['longitude'] ??
                              0,
                        ),
                        _buildWeatherCard(
                          city: dc.defaultWeatherList[1].specLocation,
                          weatherType: dc.defaultWeatherList[1].main,
                          humidity: dc.defaultWeatherList[1].humidity,
                          wind: dc.defaultWeatherList[1].windSpeed,
                          icon: dc.defaultWeatherList[1].icon,
                          temp: dc.defaultWeatherList[1].temp,
                          latitude: dc.cities[dc.defaultWeatherList[1]
                                  .specLocation]!['latitude'] ??
                              0,
                          longitude: dc.cities[dc.defaultWeatherList[1]
                                  .specLocation]!['longitude'] ??
                              0,
                        ),
                        Visibility(
                          visible: dc.addedWeatherList.isNotEmpty,
                          child: Column(
                            children: [
                              for (var weather in dc.addedWeatherList)
                                _buildWeatherCard(
                                  city: weather.specLocation,
                                  weatherType: weather.main,
                                  humidity: weather.humidity,
                                  wind: weather.windSpeed,
                                  icon: weather.icon,
                                  temp: weather.temp,
                                  latitude: weather.latitude!,
                                  longitude: weather.longitude!,
                                ),
                            ],
                          ),
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
      margin: const EdgeInsets.only(top: 25, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: AnimatedSwitcher(
        switchInCurve: Curves.fastEaseInToSlowEaseOut,
        switchOutCurve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: showSearchBar
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  onTapOutside: (event) {
                    setState(() {
                      showSearchBar = false;
                    });
                  },
                  style: Theme.of(context).textTheme.titleSmall,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search...',
                  ),
                ),
              )
            : Row(
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
                    onPressed: () {
                      setState(() {
                        showSearchBar = true;
                      });
                    },
                    icon: Image.asset(
                      'assets/search_icon.png',
                    ),
                  )
                ],
              ),
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
        dc.latitude = latitude;
        dc.longtude = longitude;

        setState(() {
          isLoading = true;
        });
        dc.fetchFromSelection = true;
        dc.theNext3DaysWeatherList.clear();
        final isFetched = await dc.isWeatherFetched();
        await dc.getBackgroundImage(dc.selectedWeather!.specLocation);
        setState(() {
          isLoading = false;
        });

        if (isFetched == true) {
          Get.offAll(() => const HomeScreen());
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
                  const SizedBox(height: 20),
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
                Text('${dc.toCelsius(temp)}ºC',
                    style: Theme.of(context).textTheme.displayLarge)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildAddNewButton() {
    return InkWell(
      onTap: () async {
        Get.dialog(
          SizedBox(
            height: screenHeight(context) * 0.5,
            child: Dialog(
              child: ListView.builder(
                itemCount: citiesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      Get.back();
                      setState(() {
                        isLoading = true;
                      });
                      await dc.fetchWeatherUsingCoordinate(
                        latitude: double.parse(citiesList[index][2]),
                        longitude: double.parse(citiesList[index][3]),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text(
                            '${citiesList[index][0]}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
        setState(() {
          isAddButtonClicked = true;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          isAddButtonClicked = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(microseconds: 500),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 10, bottom: 30),
        width: isAddButtonClicked
            ? screenWidth(context) * 0.97
            : screenWidth(context) * 0.95,
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
      ),
    );
  }
}
