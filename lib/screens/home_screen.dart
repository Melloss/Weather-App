import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/screens/weather_list.dart';
import '../utilities/color_pallet.dart';
import '../utilities/media_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ColorPallet {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset('assets/Preview.png', fit: BoxFit.cover),
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
                const Icon(Icons.location_on),
                const SizedBox(width: 10),
                Text(
                  'New York',
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
            'June 10',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(
            'Updates as of 10:14 PM GMT-4',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Image.asset(
            'assets/sunny.png',
            fit: BoxFit.cover,
          ),
          Text(
            'Sunny',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '33',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconDetail('assets/humidity.png', 'HUMIDITY', '52%'),
              _buildIconDetail('assets/wind.png', 'WIND', '15Km/h'),
              _buildIconDetail('assets/feels_like.png', 'FEELS LIKE', '24º'),
            ],
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
                _buildDayWeather('Wed 16', 'assets/half_cloudy.png', 22, '1-5'),
                _buildDayWeather(
                    'Thu 17', 'assets/sun_with_cloud.png', 25, '1-5'),
                _buildDayWeather(
                    'Fro 18', 'assets/sun_with_cloud.png', 23, '1-5'),
                _buildDayWeather('Sat 19', 'assets/raining.png', 25, '1-5'),
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

  _buildDayWeather(String day, String imagePath, int temprature, String wind) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 15),
              Text(
                day,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ],
          ),
          Positioned(
            left: 35,
            top: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
          )
        ],
      ),
    );
  }
}
