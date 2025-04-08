import 'package:flutter/material.dart';
import 'package:rbgo/authScreens/loginScreen.dart';
import 'package:rbgo/main.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/img.png"),
          SizedBox(
            height: 25,
          ),
          Text(
            "Get Started with RB Go",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 25,
          ),
          InkWell(
            onTap: (){
              navi(context, Loginscreen());
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(),
                  Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_right_alt_outlined,
                    color: Colors.white,
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(15)),
              height: 55,
              width: 300,
            ),
          )
        ],
      ),
    );
  }
}
