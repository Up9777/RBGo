import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rbgo/home/homePage.dart';

class confirmRide extends StatefulWidget {
  final String rideType;
  final double rent;
  final String pickupLocation;

  const confirmRide({
    super.key,
    required this.rideType,
    required this.rent,
    required this.pickupLocation,
  });

  @override
  State<confirmRide> createState() => _confirmRideState();
}

class _confirmRideState extends State<confirmRide> {
  // Stream of active drivers
  Stream<QuerySnapshot> get _activeDriversStream => FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'Driver')
      .where('isActive', isEqualTo: true)
      .snapshots();

  // Function to save trip data to Firestore
  Future<void> _saveTripData(List<Map<String, String>> activeDrivers) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user signed in.');
      }

      // Fetch current user's data
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        throw Exception('User data not found.');
      }
      final userData = userDoc.data()!;

      // Select the first active driver (for simplicity)
      if (activeDrivers.isEmpty) {
        throw Exception('No active drivers available.');
      }
      final selectedDriver = activeDrivers[0];
      final driverDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: selectedDriver['name'])
          .where('mobile', isEqualTo: selectedDriver['mobile'])
          .where('role', isEqualTo: 'Driver')
          .get();
      if (driverDoc.docs.isEmpty) {
        throw Exception('Driver data not found.');
      }
      final driverData = driverDoc.docs.first.data();
      final driverId = driverDoc.docs.first.id;

      // Save trip data to allRides collection
      await FirebaseFirestore.instance.collection('allRides').add({
        'status': "pending",
        'tripData': {
          'rideType': widget.rideType,
          'rent': widget.rent,
          'pickupLocation': widget.pickupLocation,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'userData': {
          'userId': user.uid,
          'name': userData['name'],
          'email': userData['email'],
          'mobile': userData['mobile'],
        },
        'driverData': {
          'driverId': driverId,
          'name': driverData['name'],
          'mobile': driverData['mobile'],
        },
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save trip: $e'),
          backgroundColor: Colors.black,
        ),
      );
      rethrow; // Rethrow to prevent navigation if saving fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: StreamBuilder<QuerySnapshot>(
                stream: _activeDriversStream,
                builder: (context, snapshot) {
                  // Handle loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }

                  // Handle error state
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }

                  // Handle data state
                  final docs = snapshot.data?.docs ?? [];
                  final activeDrivers = docs.map((doc) {
                    return {
                      'name': doc['name'] as String,
                      'mobile': doc['mobile'] as String,
                    };
                  }).toList();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Available Drivers',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: activeDrivers.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.directions_car_outlined,
                                      color: Colors.white70,
                                      size: 60,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'No active drivers available.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: activeDrivers.length,
                                itemBuilder: (context, index) {
                                  final driver = activeDrivers[index];
                                  return Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          color: Colors.white, width: 1),
                                    ),
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.black,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        driver['name']!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Mobile: ${driver['mobile']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Confirm the pickup location',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.pickupLocation,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    child: Center(
                      child: ListTile(
                        title: Text(
                          widget.rideType,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          'Rs${widget.rent.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _activeDriversStream,
                    builder: (context, snapshot) {
                      final hasActiveDrivers =
                          snapshot.hasData && snapshot.data!.docs.isNotEmpty;
                      final activeDriversList = snapshot.hasData
                          ? snapshot.data!.docs.map((doc) {
                              return {
                                'name': doc['name'] as String,
                                'mobile': doc['mobile'] as String,
                              };
                            }).toList()
                          : <Map<String, String>>[];
                      return InkWell(
                        onTap: hasActiveDrivers
                            ? () async {
                                try {
                                  // Save trip data to Firestore
                                  await _saveTripData(activeDriversList);
                                  // Show confirmation message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Booking confirmed for ${widget.rideType} at Rs${widget.rent.toStringAsFixed(2)}'),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                  // Navigate back to the previous screen
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Homepage()));
                                } catch (e) {
                                  // Error already handled in _saveTripData
                                }
                              }
                            : null,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(),
                              Text(
                                'Confirm ${widget.rideType}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_right_alt_outlined,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color:
                                hasActiveDrivers ? Colors.white : Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          height: 55,
                          width: 350,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            height: 250,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
