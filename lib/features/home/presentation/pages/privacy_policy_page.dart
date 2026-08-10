import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Futoshiki for Adults does not collect, store, or share any personal data.\n\n'
              'This app works entirely offline. No internet connection is required to play.\n\n'
              'This app contains no advertisements of any kind.\n\n'
              'No in-app purchases are available.\n\n'
              'If you have any questions, please contact the developer.',
              style: TextStyle(fontSize: 16, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
