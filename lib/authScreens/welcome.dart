import 'package:flutter/material.dart';
import 'package:rbgo/home/Profile.dart';
import 'package:rbgo/home/homePage.dart';
import 'package:rbgo/main.dart';

class WelcomeScreen extends StatelessWidget {
  String name;
  WelcomeScreen({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Welcome, $name",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Here's what you need to do to set up your account.",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Profile Photo"),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Icon(Icons.camera_alt, color: Colors.grey),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Driving License"),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Vehicle Insurance"),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Registration Certificate"),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Vehicle Commercial Permit"),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: () {
                navi(context, Homepage());
              },
              child: Container(
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 55,
                width: 350,
              ),
            ),
          ],
        ),
      ),
    );
  }
}