import 'package:flutter/material.dart';

const kMainColor = Color(0xFF795548);
const kSubColor = Color(0xFF8D6E63);
const kMainTextColor = Color(0xFF424242);
const kSubTextColor = Color(0xFF616161);

const TextStyle kTitleTextStyle = TextStyle(
  color: kMainColor,
  fontSize: 32.0,
  fontWeight: FontWeight.bold,
);

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'NotoSansJP',
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 4.0,
      centerTitle: false,
      brightness: Brightness.light,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kSubTextColor,
          fontSize: 18.0,
        ),
      ),
      iconTheme: IconThemeData(color: kMainColor),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: kMainTextColor),
      bodyText2: TextStyle(color: kMainTextColor),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

const BoxDecoration kNavigationDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 4.0,
    ),
  ],
);

const BoxDecoration kBottomBorderDecoration = BoxDecoration(
  border: Border(
    bottom: BorderSide(
      width: 1.0,
      color: Color(0xFFE0E0E0),
    ),
  ),
);
