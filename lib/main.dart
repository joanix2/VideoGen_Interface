import 'package:flutter/material.dart';
import 'connexion.dart';
import 'config.dart';
import 'main_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: color2Swatch,
        scaffoldBackgroundColor: color3,
        appBarTheme: const AppBarTheme(
          color: color1,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: color2, // This is a custom color variable
          ),
        ),
      ),
      title: 'VideoGen',
      home: const LoginPage(),
      //home: const MainFrame(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6ImpvYW5peDIiLCJleHAiOjE2OTc5MjI5NTUsImVtYWlsIjoiIiwib3JpZ19pYXQiOjE2OTc4MzY1NTV9.m1_juPj-TVSFjdck9mwhTu5Kg5NN-FFk1joTzH50BOk", projectName: "projet 1", id: 3,)
    );
  }
}