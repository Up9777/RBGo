import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:rbgo/home/chooseRide.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get status chip with dynamic colors
  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase().trim()) {
      case 'ongoing':
        chipColor = Colors.green.shade600;
        break;
      case 'pending':
        chipColor = Colors.orange.shade600;
        break;
      case 'completed':
        chipColor = Colors.grey.shade600;
        break;
      default:
        chipColor = Colors.blue.shade600;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: chipColor,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Function to submit rating to Firestore
  Future<void> _submitRating(String rideId, double rating) async {
    try {
      await _firestore.collection('allRides').doc(rideId).update({
        'tripData.rating': rating,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting rating: $e')),
      );
    }
  }

  // Format Firestore timestamp to readable date/time
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy, hh:mma').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Activity",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (user == null)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffd9d9d9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const ListTile(
                    leading: Icon(Icons.error_outline, color: Colors.red),
                    title: Text(
                      'No user signed in',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('allRides')
                      .where('userData.userId', isEqualTo: user.uid)
                      .orderBy('tripData.timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      String errorMsg = 'Error loading rides';
                      if (snapshot.error
                          .toString()
                          .contains('FAILED_PRECONDITION')) {
                        errorMsg =
                            'Firestore index required. Please create the index using the link in the console.';
                      }
                      print('Firestore Error: ${snapshot.error}');
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: ListTile(
                          leading: const Icon(Icons.error_outline,
                              color: Colors.red),
                          title: const Text(
                            'Error loading rides',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(errorMsg),
                        ),
                      );
                    }

                    final rides = snapshot.data?.docs ?? [];
                    if (rides.isEmpty) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const ListTile(
                          leading: Icon(
                            Icons.directions_car_outlined,
                            color: Colors.grey,
                          ),
                          title: Text(
                            'No rides found',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Book a new ride to see it here'),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rides.length,
                      itemBuilder: (context, index) {
                        final ride = rides[index];
                        final rideId = ride.id;
                        final tripData =
                            ride['tripData'] as Map<String, dynamic>? ?? {};
                        final driverData =
                            ride['driverData'] as Map<String, dynamic>? ?? {};
                        final status = ride['status']?.toString() ?? 'unknown';
                        final rating = tripData['rating']?.toDouble() ?? 0.0;

                        // Debug print
                        print(
                            'Ride $index: ID=$rideId, Status=$status, Rating=$rating');

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffd9d9d9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tripData['rideType']?.toString() ??
                                          'Unknown',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    _buildStatusChip(status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/img_8.png',
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '₹${tripData['rent']?.toStringAsFixed(2) ?? '0.00'}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _formatTimestamp(
                                              tripData['timestamp']),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'From: ${tripData['pickupLocation']?.toString() ?? 'Unknown'}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Driver: ${driverData['name']?.toString() ?? 'Unknown'}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (status.toLowerCase().trim() == 'completed')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: rating,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 18.0,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 2.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (newRating) {
                                              _submitRating(rideId, newRating);
                                            },
                                          ),
                                          if (rating > 0)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                '($rating)',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
