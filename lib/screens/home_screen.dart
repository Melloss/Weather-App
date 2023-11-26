import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_image/shimmer_image.dart';

import '../controllers/data_controller.dart';
import '../screens/weather_list.dart';
import '../utilities/color_pallet.dart';
import '../utilities/media_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ColorPallet {
  DataController dc = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Obx(() => dc.backgroundImage.isEmpty
            ? Image.asset(
                'assets/preview.jpg',
                fit: BoxFit.cover,
                width: screenWidth(context),
                height: screenHeight(context),
              )
            : ProgressiveImage(
                image: dc.backgroundImage.value,
                width: screenWidth(context),
                fit: BoxFit.cover,
                height: screenHeight(context),
              )),
        Positioned(
          child: Container(
            width: screenWidth(context),
            height: screenHeight(context),
            color: backgroundDropColor,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLocationAndDrawer(),
                  _buildDateAndTemprature(),
                  _buildBottom(),
                ]),
          ),
        )
      ]),
    );
  }

  _buildLocationAndDrawer() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: screenWidth(context),
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 32,
                ),
                const SizedBox(width: 10),
                Text(
                  dc.isWeatherSelected.value == true
                      ? dc.selectedWeather!.specLocation
                      : dc.todayWeather!.specLocation,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  Get.to(
                    () => const WeatherList(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 500),
                  );
                },
                icon: const Icon(Icons.menu))
          ],
        ),
      ),
    );
  }

  _buildDateAndTemprature() {
    return SizedBox(
      width: screenWidth(context),
      child: Column(
        children: [
          Text(
            //month date
            '${dc.getMonth(dc.todayWeather!.updatedTime.month)} ${dc.todayWeather!.updatedTime.day}',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(
            'Updates as of ${dc.isWeatherSelected.value ? dc.selectedWeather!.updatedTime.hour : dc.todayWeather!.updatedTime.hour}:${dc.isWeatherSelected.value ? dc.selectedWeather!.updatedTime.minute : dc.todayWeather!.updatedTime.minute} ${dc.todayWeather!.updatedTime.timeZoneName}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          CachedNetworkImage(
              imageUrl:
                  'http://openweathermap.org/img/wn/${dc.isWeatherSelected.value ? dc.selectedWeather!.icon : dc.todayWeather!.icon}@2x.png'),
          Text(
            dc.isWeatherSelected.value
                ? dc.selectedWeather!.main
                : dc.todayWeather!.main,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dc.toCelsius(dc.isWeatherSelected.value ? dc.selectedWeather!.temp : dc.todayWeather!.temp)}',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 60,
                      ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'ºc',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildBottom() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: screenWidth(context),
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconDetail('assets/humidity.png', 'HUMIDITY',
                    '${dc.isWeatherSelected.value ? dc.selectedWeather!.humidity : dc.todayWeather!.humidity}%'),
                _buildIconDetail('assets/wind.png', 'WIND',
                    '${dc.isWeatherSelected.value ? dc.selectedWeather!.windSpeed : dc.todayWeather!.windSpeed}Km/h'),
                _buildIconDetail('assets/feels_like.png', 'FEELS LIKE',
                    '${dc.toCelsius(dc.isWeatherSelected.value ? dc.selectedWeather!.feelsLike : dc.todayWeather!.feelsLike)}ºc'),
              ],
            ),
          ),
          Container(
            width: screenWidth(context),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            height: 170,
            decoration: BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDayWeather(
                    '${dc.getWeek(dc.isWeatherSelected.value ? dc.selectedWeather!.updatedTime.weekday : dc.todayWeather!.updatedTime.weekday)} ${dc.todayWeather!.updatedTime.day}',
                    'http://openweathermap.org/img/wn/${dc.isWeatherSelected.value ? dc.selectedWeather!.icon : dc.todayWeather!.icon}@2x.png',
                    dc.toCelsius(dc.isWeatherSelected.value
                        ? dc.selectedWeather!.temp
                        : dc.todayWeather!.temp),
                    dc.isWeatherSelected.value
                        ? dc.selectedWeather!.windSpeed
                        : dc.todayWeather!.windSpeed),
                _buildDayWeather(
                  '${dc.getWeek((dc.isWeatherSelected.value ? dc.selectedWeather!.updatedTime.weekday : dc.todayWeather!.updatedTime.weekday) + 1)} ${(dc.isWeatherSelected.value ? dc.selectedWeather!.updatedTime.day : dc.todayWeather!.updatedTime.day) + 1}',
                  'http://openweathermap.org/img/wn/${dc.theNext3DaysWeatherList[0].icon}@2x.png',
                  dc.toCelsius(dc.theNext3DaysWeatherList[0].temp),
                  dc.theNext3DaysWeatherList[0].windSpeed,
                ),
                _buildDayWeather(
                  '${dc.getWeek(dc.todayWeather!.updatedTime.weekday + 2)} ${dc.todayWeather!.updatedTime.day + 2}',
                  'http://openweathermap.org/img/wn/${dc.theNext3DaysWeatherList[1].icon}@2x.png',
                  dc.toCelsius(dc.theNext3DaysWeatherList[1].temp),
                  dc.theNext3DaysWeatherList[1].windSpeed,
                ),
                _buildDayWeather(
                  '${dc.getWeek(dc.todayWeather!.updatedTime.weekday + 3)} ${dc.todayWeather!.updatedTime.day + 3}',
                  'http://openweathermap.org/img/wn/${dc.theNext3DaysWeatherList[2].icon}@2x.png',
                  dc.toCelsius(dc.theNext3DaysWeatherList[2].temp),
                  dc.theNext3DaysWeatherList[2].windSpeed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildIconDetail(String path, String title, String des) {
    return Column(
      children: [
        Image.asset(path),
        const SizedBox(height: 3),
        Text(title, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 3),
        Text(des, style: Theme.of(context).textTheme.displayMedium),
      ],
    );
  }

  _buildDayWeather(
      String day, String imagePath, double temprature, double wind) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Text(
                day,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              CachedNetworkImage(
                imageUrl: imagePath,
                width: 100,
                height: 50,
              ),
              Text(
                '$tempratureº',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 7),
              Text(
                '$wind\nkm/h',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 11,
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
