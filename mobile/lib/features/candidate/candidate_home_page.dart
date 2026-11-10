
import 'package:flutter/material.dart';
import '../../widgets/user_dropdown.dart';

class CandidateHomePage extends StatelessWidget {
  const CandidateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
  title: const Text('JobMatch AI'),
  actions: const [
    UserDropdown(),
    SizedBox(width: 16),
  ],
),
      body: const Center(
        child: Text(
          'Welcome Candidate!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
