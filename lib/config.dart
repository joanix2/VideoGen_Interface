import 'package:flutter/material.dart';

double pad = 10;

const Color color1 = Color(0xFF992534); // #992534
const Color color2 = Color(0xFF123D47); // #123d47
const Color color3 = Color(0xFFCA8771); // #ca8771
const Color whiteWithOpacity50 = Color.fromRGBO(255, 255, 255, 0.5);


// Créez une instance de MaterialColor à partir de color2
final MaterialColor color2Swatch = MaterialColor(
  color2.value,
  const <int, Color>{
    50: Color(0xFFADD7E3),
    100: Color(0xFFC9F3FF),
    200: Color(0xFF78A0AC),
    300: Color(0xFF0F3B45),
    400: Color(0xFF123D47),
    500: color2,
    600: color2,
    700: color2,
    800: color2,
    900: color2,
  },
);

TextStyle? title1 = const TextStyle(fontSize: 20, color: color2);
TextStyle? title2 = const TextStyle(fontSize: 15, color: color2);

