import 'package:flutter/material.dart';
import 'package:rbgo/authScreens/register.dart';
import 'package:rbgo/home/Profile.dart';
import 'package:rbgo/home/homePage.dart';
import 'package:rbgo/main.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool isCustomer = true;

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
                "Enter Your Mobile Number",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Mobile No."),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: '+91 1234567890',
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Password"),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: '******',
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign in as: '),
                Switch(
                  value: isCustomer,
                  onChanged: (value) {
                    setState(() {
                      isCustomer = value;
                    });
                  },
                  activeColor: Colors.black,
                  activeTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade400,
                ),
                Text(isCustomer ? 'Customer' : 'Driver'),
              ],
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                navi(context, Homepage());
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(),
                    Text(
                      'Sign In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15)),
                height: 55,
                width: 350,
              ),
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  'Forget password?',
                  style: TextStyle(color: Colors.grey),
                )),

            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("or"),
                ),
                Expanded(child: Divider())
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                child: Center(
                    child: Text(
                      'Continue with Google',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                child: Center(
                    child: Text(
                      'Continue with Apple',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    // Add navigation to signup screen here, e.g.,
                    navi(context, SignupScreen());
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}