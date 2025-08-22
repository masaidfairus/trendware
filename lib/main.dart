import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/splash_page.dart';
// import 'controllers/news_controller.dart';
import 'controllers/theme_controller.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'TrendWare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 30, 58, 138),
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(255, 30, 58, 138),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 30, 58, 138),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        home: SplashPage(),
      ),
    );
  }
}
