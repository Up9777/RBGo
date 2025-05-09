import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _giftCardController = TextEditingController();
  double walletBalance = 0.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWalletBalance();
  }

  // Load wallet balance from Firestore
  Future<void> _loadWalletBalance() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            walletBalance = (userDoc.get('walletBalance') ?? 0.0).toDouble();
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading wallet balance.')),
      );
    }
  }

  // Redeem gift card
  Future<void> _redeemGiftCard() async {
    final code = _giftCardController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a gift card code.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user signed in.')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Check gift card code in Firestore
      DocumentSnapshot giftCardDoc =
          await _firestore.collection('giftCodes').doc('1').get();

      if (!giftCardDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid gift card code.')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      final giftCardData = giftCardDoc.data() as Map<String, dynamic>;
      if (giftCardData['code'] != code) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid gift card code.')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      final double giftValue = (giftCardData['value'] as num).toDouble();

      // Update wallet balance
      await _firestore.collection('users').doc(user.uid).set(
        {
          'walletBalance': FieldValue.increment(giftValue),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // Update local balance
      setState(() {
        walletBalance += giftValue;
        isLoading = false;
      });

      _giftCardController.clear();
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('₹$giftValue added to your wallet.')),
      );
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error redeeming gift card.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show gift card dialog
  void _showGiftCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redeem Gift Card'),
        content: TextField(
          controller: _giftCardController,
          decoration: InputDecoration(
            labelText: 'Gift Card Code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: isLoading ? null : _redeemGiftCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _giftCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              "Wallet",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffd9d9d9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "RB Go Cash",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "₹${walletBalance.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 35),
                        ),
                        const SizedBox(height: 35),
                        InkWell(
                          onTap: isLoading ? null : _showGiftCardDialog,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "+ Gift Card",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
