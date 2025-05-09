import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_launcher/map_launcher.dart';

class DriverTripsScreen extends StatelessWidget {
  const DriverTripsScreen({super.key});

  // Function to handle ride acceptance
  Future<void> _acceptRide(BuildContext context, String rideId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Fetch the ride document to get pickup and destination locations
      final rideDoc = await FirebaseFirestore.instance
          .collection('allRides')
          .doc(rideId)
          .get();

      if (!rideDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride not found.')),
        );
        return;
      }

      final tripData = rideDoc['tripData'] as Map<String, dynamic>? ?? {};
      final pickupLocation = tripData['pickupLocation']?.toString();
      final destinationLocation = tripData['destinationLocation']?.toString();

      // Update ride status to ongoing
      await FirebaseFirestore.instance
          .collection('allRides')
          .doc(rideId)
          .update({
        'status': 'ongoing',
      });

      // Set driver to offline to prevent new assignments
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'isActive': false,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ride started!'),
          backgroundColor: Colors.black,
        ),
      );

      // Launch Google Maps for navigation
      if (pickupLocation != null) {
        try {
          // Check if Google Maps is available
          final availableMaps = await MapLauncher.installedMaps;
          final googleMap = availableMaps.firstWhere(
            (map) => map.mapType == MapType.google,
            orElse: () => throw Exception('Google Maps not installed'),
          );

          // Use showMarker with fallback coordinates for pickupLocation
          await googleMap.showMarker(
            coords: Coords(
                19.1197, 72.8464), // Default coordinates for Andheri, Mumbai
            title: pickupLocation,
            description: 'Pickup Location',
          );

          // If destinationLocation is available, use showDirections
          /*
          if (destinationLocation != null) {
            await googleMap.showDirections(
              origin: Coords(19.1197, 72.8464), // Andheri
              originTitle: pickupLocation,
              destination: Coords(19.0544, 72.8402), // Example: Bandra
              destinationTitle: destinationLocation,
              mode: DirectionsMode.driving,
            );
          }
          */
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch Google Maps: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pickup location missing.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start ride: $e')),
      );
    }
  }

  // Function to handle ride completion
  Future<void> _endTrip(BuildContext context, String rideId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Update ride status to completed
      await FirebaseFirestore.instance
          .collection('allRides')
          .doc(rideId)
          .update({
        'status': 'completed',
      });

      // Set driver back to online
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'isActive': true,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip ended successfully!'),
          backgroundColor: Colors.black,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to end trip: $e')),
      );
    }
  }

  // Function to handle ride rejection
  Future<void> _rejectRide(BuildContext context, String rideId) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ride rejected.'),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user signed in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'My Trip Requests',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('allRides')
              .where('driverData.driverId', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final trips = snapshot.data?.docs ?? [];
            if (trips.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      color: Colors.white70,
                      size: 60,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No trip requests found.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final tripData =
                    trip['tripData'] as Map<String, dynamic>? ?? {};
                final userData =
                    trip['userData'] as Map<String, dynamic>? ?? {};
                final status = trip['status'] as String? ?? 'pending';

                if (tripData.isEmpty || userData.isEmpty) {
                  return const Card(
                    child: ListTile(
                      title: Text('Invalid trip data'),
                      subtitle: Text('Missing trip or user information'),
                    ),
                  );
                }

                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.white, width: 1),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            tripData['rideType']?.toString() ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            'Status: $status',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rent: Rs${tripData['rent']?.toStringAsFixed(2) ?? '0.00'}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pickup: ${tripData['pickupLocation']?.toString() ?? 'Unknown'}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'User: ${userData['name']?.toString() ?? 'Unknown'}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'User Mobile: ${userData['mobile']?.toString() ?? 'Unknown'}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        if (status == 'pending') ...[
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _rejectRide(context, trip.id),
                                child: const Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _acceptRide(context, trip.id),
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (status == 'ongoing') ...[
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _endTrip(context, trip.id),
                                child: const Text(
                                  'End Trip',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
