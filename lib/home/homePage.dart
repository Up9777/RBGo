import 'package:flutter/material.dart';
import 'package:rbgo/home/Profile.dart';
import 'package:rbgo/home/chooseRide.dart';
import 'package:rbgo/home/rides.dart';
import 'package:rbgo/main.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                navi(context, Profile());
              },
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/img_7.png"),
                radius: 25,
                backgroundColor: Colors.grey,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Hello Utkarsh',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "What are you looking \nfor today",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    navi(context, Rides());
                  },
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 95,
                              width: 95,
                              child: Image.asset(
                                "assets/img_1.png",
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rides',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 95,
                            width: 95,
                            child: Image.asset(
                              "assets/img_2.png",
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Eats',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset("assets/img_3.png"),
                        ),
                      ),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Pantry',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset("assets/img_4.png"),
                        ),
                      ),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Transit', // Replace with appropriate text
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset("assets/img_5.png"),
                        ),
                      ),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Scooter', // Replace with appropriate text
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset("assets/img_6.png"),
                        ),
                      ),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Connect', // Replace with appropriate text
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Go Again',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                radius: 25,
                child: ClipOval(
                  child: Image.asset(
                    'assets/img_8.png',
                    fit: BoxFit.cover,
                    width: 40, // Adjust the width as needed
                    height: 40, // Adjust the height as needed
                  ),
                ),
              ),
              title: Text("RB X > WORK"),
              subtitle: Text("\$23 - 5 min away"),
              trailing: Icon(Icons.arrow_right_alt),
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                radius: 25,
                child: ClipOval(
                  child: Image.asset(
                    'assets/img_9.png',
                    fit: BoxFit.cover,
                    width: 40, // Adjust the width as needed
                    height: 40, // Adjust the height as needed
                  ),
                ),
              ),
              title: Text("Premium > Bay Club"),
              subtitle: Text("\$23 - 5 min away"),
              trailing: Icon(Icons.arrow_right_alt),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
