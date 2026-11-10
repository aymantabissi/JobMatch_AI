
import 'package:flutter/material.dart';
import '../widgets/user_dropdown.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobMatch AI'),
        actions: const [
          UserDropdown(),
          SizedBox(width: 10),
        ],
      ),

      body: const Center(
        child: Text('Welcome to JobMatch AI'),
      ),
    );
  }
}
