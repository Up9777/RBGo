import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import '../main.dart';
import 'confirmBooking.dart';

class Chooseride extends StatefulWidget {
  final String currentLocation;
  final String destination;
  final String type;

  const Chooseride({
    super.key,
    required this.currentLocation,
    required this.destination,
    required this.type,
  });

  @override
  State<Chooseride> createState() => _ChooserideState();
}

class _ChooserideState extends State<Chooseride> {
  // Map of Mumbai locations to coordinates
  final Map<String, latLng.LatLng> locationCoordinates = {
    'Bandra': const latLng.LatLng(19.0550, 72.8290),
    'Andheri': const latLng.LatLng(19.1136, 72.8697),
    'Colaba': const latLng.LatLng(18.9151, 72.8258),
    'Juhu': const latLng.LatLng(19.0988, 72.8266),
    'Powai': const latLng.LatLng(19.1164, 72.9047),
    'Malad': const latLng.LatLng(19.1867, 72.8486),
    'Versova': const latLng.LatLng(19.1300, 72.8150),
    'Dadar': const latLng.LatLng(19.0176, 72.8440),
    'Worli': const latLng.LatLng(19.0000, 72.8150),
    'Borivali': const latLng.LatLng(19.2307, 72.8567),
  };

  // Calculate center point between two locations
  latLng.LatLng getMapCenter() {
    final currentCoords = locationCoordinates[widget.currentLocation]!;
    final destinationCoords = locationCoordinates[widget.destination]!;
    return latLng.LatLng(
      (currentCoords.latitude + destinationCoords.latitude) / 2,
      (currentCoords.longitude + destinationCoords.longitude) / 2,
    );
  }

  // Calculate distance between two coordinates in kilometers
  double calculateDistance() {
    final currentCoords = locationCoordinates[widget.currentLocation]!;
    final destinationCoords = locationCoordinates[widget.destination]!;
    final distance = const latLng.Distance().as(
      latLng.LengthUnit.Kilometer,
      currentCoords,
      destinationCoords,
    );
    return distance;
  }

  // Determine rent based on distance
  double calculateRent() {
    final distance = calculateDistance();
    if (distance <= 5) {
      return 20.0;
    } else if (distance <= 10) {
      return 40.0;
    } else if (distance <= 20) {
      return 60.0;
    } else {
      return 80.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCoords = locationCoordinates[widget.currentLocation]!;
    final destinationCoords = locationCoordinates[widget.destination]!;
    final rent = calculateRent();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: getMapCenter(),
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [currentCoords, destinationCoords],
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentCoords,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: destinationCoords,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            height: 270,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  'From: ${widget.currentLocation} To: ${widget.destination}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    child: Center(
                      child: ListTile(
                        subtitle: const Text(
                          '2.23 am drop-off\nLonger wait',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        trailing: Text(
                          'Rs.${rent.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        title: Text(
                          "Book ${widget.type}",
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Cash',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkWell(
                    onTap: () {
                      navi(
                        context,
                        confirmRide(
                          rideType: widget.type,
                          rent: rent,
                          pickupLocation: widget.currentLocation,
                        ),
                      );
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(),
                          Text(
                            'Choose ${widget.type}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 55,
                      width: 350,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
