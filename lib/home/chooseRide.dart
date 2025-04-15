import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:rbgo/home/confirmBooking.dart';
import 'package:rbgo/main.dart';

class Chooseride extends StatefulWidget {
  const Chooseride({super.key});

  @override
  State<Chooseride> createState() => _ChooserideState();
}

class _ChooserideState extends State<Chooseride> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: latLng.LatLng(40.7128, -74.0060), // Approximate New York coordinates
                // zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: 5),
                Text(
                  '10% promo code applied',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    child: Center(
                      child: ListTile(
                        subtitle: Text(
                          '2.23 am drop-off\nLonger wait',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        trailing: Text(
                          '\$68.97',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        title: Text(
                          'Rb Auto',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                'assets/img_1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Cash',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkWell(
                    onTap: () {
                      navi(context, confirmRide());
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(),
                          Text(
                            'Choose Uber Auto',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.black,
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      height: 55,
                      width: 350,
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                )),
            height: 270,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}