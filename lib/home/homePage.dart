import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rbgo/home/Profile.dart';
import 'package:rbgo/home/chooseRide.dart';
import 'package:rbgo/home/rides.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userName = 'User'; // Default name while loading
  bool isLoading = true;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // Function to fetch user name from Firestore
  Future<void> _fetchUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc.get('name') ?? 'User';
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user signed in.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching user data.')),
      );
    }
  }

  // Function to get the initial of the user's name
  String _getInitial(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

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
        chipColor = Colors.blue.shade600; // Fallback for unknown statuses
    }

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ride status: $status'),
            backgroundColor: Colors.black,
          ),
        );
      },
      child: Chip(
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

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade400,
                  child: Text(
                    _getInitial(userName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              isLoading
                  ? const Text(
                      'Loading...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    )
                  : Text(
                      'Hello $userName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
              const SizedBox(height: 10),
              const Text(
                "What are you looking \nfor today",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  height: 1.2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Rides(
                                  type: 'cab',
                                )),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 95,
                              width: 95,
                              child: Image.asset("assets/img_1.png"),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Rides',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Rides(
                                  type: 'auto',
                                )),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 95,
                              width: 95,
                              child: Image.asset("assets/Autorickshaw.png"),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Auto',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Rides',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (user == null)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const ListTile(
                                leading: Icon(Icons.error_outline,
                                    color: Colors.red),
                                title: Text(
                                  'Error loading rides',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text('Please try again later'),
                              ),
                            );
                          }

                          final rides = snapshot.data?.docs ?? [];
                          if (rides.isEmpty) {
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const ListTile(
                                leading: Icon(
                                  Icons.directions_car_outlined,
                                  color: Colors.grey,
                                ),
                                title: Text(
                                  'No rides found',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle:
                                    Text('Book a new ride to see it here'),
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
                                  ride['tripData'] as Map<String, dynamic>? ??
                                      {};
                              final driverData =
                                  ride['driverData'] as Map<String, dynamic>? ??
                                      {};
                              final status =
                                  ride['status']?.toString() ?? 'unknown';
                              final rating = tripData['rating']?.toDouble() ??
                                  0.0; // Default to 0.0 if rating missing

                              // Debug print to check status
                              print('Ride $index: Status = $status');

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Rides(type: 'cab'),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey.shade400,
                                        radius: 25,
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/img_8.png', // Replace with dynamic image if available
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        '${tripData['rideType']?.toString() ?? 'Unknown'} > ${tripData['pickupLocation']?.toString() ?? 'Unknown'}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${tripData['rent']?.toStringAsFixed(2) ?? '0.00'} - Driver: ${driverData['name']?.toString() ?? 'Unknown'}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          _buildStatusChip(status),
                                          if (status.toLowerCase().trim() ==
                                              'completed')
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
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize:
                                                          18.0, // Reduced size to avoid overflow
                                                      itemPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 2.0),
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (newRating) {
                                                        _submitRating(
                                                            rideId, newRating);
                                                      },
                                                    ),
                                                    if (rating > 0)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          '($rating)',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey.shade600,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          else
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                'Rating available after trip completion',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
