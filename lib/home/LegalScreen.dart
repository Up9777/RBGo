import 'package:flutter/material.dart';

class LegalInfoScreen extends StatelessWidget {
  const LegalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Information'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SectionTitle("🚖 RB GO  – Legal Information"),
            Text("Effective Date: 14-March-25\nLast Updated: 04-May-2025\n"),

            SectionTitle("🔒 Privacy Policy"),
            LegalText("""
RB GO respects your privacy. This Privacy Policy outlines how we collect, use, and protect your information.

Information We Collect:
- Personal Data: Name, email, phone number, profile picture.
- Location Data: Real-time GPS during ride activity.
- Payment Info: Processed securely via third-party gateways.

How We Use It:
- Connect drivers with riders.
- Track rides and process payments.
- Improve service and user experience.

Sharing of Information:
- With drivers/riders for ride coordination.
- With trusted service providers (e.g., payment processors).
- With authorities, if required by law.

Your Rights:
- Update or delete your data by contacting support@[rbgo].com.

Security:
We use encryption and secure storage, but no system is 100% secure.
"""),

            SectionTitle("📜 Terms & Conditions"),
            LegalText("""
By accessing RB Go, you agree to these terms:

1. Eligibility:
Users must be at least 18 years old and provide accurate information.

2. Account Use:
You are responsible for all activity under your account. Do not share your login credentials.

3. Ride & Payment Rules:
All rides must be paid through the app. Pricing may vary due to demand or location. Cancellations may incur a fee.

4. Conduct:
Illegal, abusive, or discriminatory behavior by riders or drivers will result in suspension or removal.

5. Limitation of Liability:
RB Go is not responsible for accidents, loss, or indirect damages during service usage.

6. Modifications:
Terms may be updated anytime. Continued use implies acceptance.
"""),

            SectionTitle("⚠️ Disclaimer"),
            LegalText("""
This app is a clone developed for learning or independent business purposes. It is not affiliated, associated, or endorsed by Uber Technologies Inc.
"""),

            SectionTitle("📬 Contact Us"),
            LegalText("""
For support or legal inquiries:
- Email: support@[rbgo].com
- Phone: +91-[9096859777]
- Address: [Mumbai]

© 2025 RB Go. All Rights Reserved.
"""),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LegalText extends StatelessWidget {
  final String text;
  const LegalText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
