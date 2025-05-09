import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rbgo/home/activity.dart';
import 'package:rbgo/home/help.dart';
import 'package:rbgo/home/settings.dart';
import 'package:rbgo/home/wallet.dart';
import 'package:rbgo/main.dart';

import '../authScreens/loginScreen.dart';
import 'LegalScreen.dart';
import 'helpForm.dart'; // Ensure this exists

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  // Function to handle logout
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isLoading
                      ? const Text(
                          'Loading...',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        )
                      : Text(
                          userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    child: Text(
                      _getInitial(userName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: const Text('5.0'),
                    ),
                  ],
                ),
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      navi(context, HelpForm());
                    },
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              child: Image.asset("assets/img_10.png"),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Help',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Wallet()),
                      );
                    },
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              child: Image.asset("assets/img_11.png"),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Payment',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Activity()),
                      );
                    },
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              child: Image.asset("assets/img_12.png"),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Activity',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(const ClipboardData(
                    text: "SAVEBIG",
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard!')),
                  );
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Click here to avail ₹50 Cashback',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                            "Tap to unlock your next ride – limited time offer!"),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              const Divider(),
              ListTile(
                onTap: () {
                  navi(context, SettingsPage());
                },
                leading: const Icon(Icons.settings),
                title: const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                onTap: () {
                  navi(context, LegalInfoScreen());
                },
                leading: const Icon(Icons.info),
                title: const Text(
                  'Legal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
