import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/home_screen.dart';
import '../controllers/data_controller.dart';
import '../utilities/color_pallet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with ColorPallet {
  bool showTryAgain = false;
  DataController dc = Get.find();

  fetchWeather() async {
    setState(() {
      showTryAgain = false;
    });
    bool isFetched = await dc.isWeatherFetched();
    setState(() {
      showTryAgain = !isFetched;
    });
    if (isFetched == true) {
      await dc.getBackgroundImage(dc.todayWeather!.specLocation);
      await Future.delayed(const Duration(seconds: 1));
      Get.to(
        () => const HomeScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 400),
      );
    }
  }

  getEveryThing() async {
    dc.getLocation().then((value) {
      fetchWeather();
    });
  }

  @override
  void initState() {
    getEveryThing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splashBackgroundColor,
      appBar: AppBar(
        backgroundColor: splashBackgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'assets/weather.gif',
            fit: BoxFit.cover,
          ),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Weather App',
                    speed: const Duration(milliseconds: 300)),
              ],
              isRepeatingAnimation: false,
              repeatForever: false,
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
          Visibility(
            visible: showTryAgain,
            child: Column(
              children: [
                Text(
                  'Try Again',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                IconButton(
                    onPressed: () {
                      fetchWeather();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 30,
                    ))
              ],
            ),
          ),
          Text(
            'Developed by Melloss',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}
