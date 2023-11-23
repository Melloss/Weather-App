import 'dart:math' show pi;

import 'package:flutter/material.dart';
import '../utilities/color_pallet.dart';
import '../utilities/media_query.dart';

class WeatherList extends StatefulWidget {
  const WeatherList({super.key});

  @override
  State<WeatherList> createState() => _WeatherListState();
}

class _WeatherListState extends State<WeatherList> with ColorPallet {
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
        child: Column(
          children: [
            _buildTop(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildWeatherCard(),
                    _buildWeatherCard(),
                    _buildWeatherCard(),
                    _buildAddNewButton(),
                  ],
                ),
              ),
            ),
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

  _buildWeatherCard() {
    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New York',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 32,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                'Sunny',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: 'Humidity ',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                  children: const [
                    TextSpan(
                      text: '52%',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  text: 'Wind ',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                  children: const [
                    TextSpan(
                      text: '115km/h',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Image.asset(
                'assets/sunny.png',
                width: 70,
                height: 70,
              ),
              Text('33ºC', style: Theme.of(context).textTheme.displayLarge)
            ],
          ),
        ],
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
