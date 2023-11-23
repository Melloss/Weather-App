import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import './screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: _buildTheme(),
    );
  }

  _buildTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      fontFamily: 'Roboto',
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 35,
      ),
      textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          titleSmall: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 37,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 18,
          )),
    );
  }
}
