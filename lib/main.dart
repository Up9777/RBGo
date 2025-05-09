import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rbgo/authScreens/getStarted.dart';
import 'package:rbgo/authScreens/loginScreen.dart';
import 'package:rbgo/authScreens/welcome.dart';
import 'package:rbgo/home/Profile.dart';
import 'package:rbgo/home/activity.dart';
import 'package:rbgo/home/chooseRide.dart';
import 'package:rbgo/home/confirmBooking.dart';
import 'package:rbgo/home/help.dart';
import 'package:rbgo/home/homePage.dart';
import 'package:rbgo/home/rides.dart';

import 'authScreens/enterPhone.dart';
import 'authScreens/register.dart';
import 'authScreens/splash.dart';
import 'driverHome/driverHome.dart';
import 'firebase_options.dart';
import 'home/wallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Future navi(context, Nextpage) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => Nextpage));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins', color: Colors.black),
          bodyMedium: TextStyle(fontFamily: 'Poppins', color: Colors.black),
          displayLarge: TextStyle(fontFamily: 'Poppins', color: Colors.black),
          displayMedium: TextStyle(fontFamily: 'Poppins', color: Colors.black),
          // Add other text styles as needed
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: Getstarted(),
    );
  }
}
