import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbgo/driverHome/driverHome.dart';
import 'package:rbgo/home/homePage.dart';

class WelcomeScreen extends StatefulWidget {
  final String name;
  const WelcomeScreen({super.key, required this.name});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController drivingLicenseController =
      TextEditingController();
  final TextEditingController vehicleInsuranceController =
      TextEditingController();
  final TextEditingController registrationCertificateController =
      TextEditingController();
  final TextEditingController vehiclePermitController = TextEditingController();
  bool isLoading = false;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save data and navigate
  Future<void> _saveAndNavigate() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user signed in.')),
        );
        return;
      }

      // Retrieve user role from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found.')),
        );
        return;
      }

      String role = userDoc.get('role') ?? 'Customer';

      // Prepare data to update
      Map<String, dynamic> updateData = {
        'drivingLicense': drivingLicenseController.text.trim(),
        'vehicleInsurance': vehicleInsuranceController.text.trim(),
        'registrationCertificate':
            registrationCertificateController.text.trim(),
        'vehiclePermit': vehiclePermitController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update user document in Firestore
      await _firestore.collection('users').doc(user.uid).update(updateData);

      // Navigate based on role
      if (mounted) {
        if (role == 'Customer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        } else if (role == 'Driver') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving data. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    drivingLicenseController.dispose();
    vehicleInsuranceController.dispose();
    registrationCertificateController.dispose();
    vehiclePermitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Center(
                child: Text(
                  "Welcome, ${widget.name}",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Complete your profile to continue.",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 35),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Driving License"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: drivingLicenseController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Enter license number',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Vehicle Insurance"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: vehicleInsuranceController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Enter insurance details',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Registration Certificate"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: registrationCertificateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Enter RC number',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Vehicle Commercial Permit"),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: vehiclePermitController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Enter permit details',
                  ),
                ),
              ),
              const SizedBox(height: 25),
              InkWell(
                onTap: isLoading ? null : _saveAndNavigate,
                child: Container(
                  decoration: BoxDecoration(
                    color: isLoading ? Colors.grey : Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 55,
                  width: 350,
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Next',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
