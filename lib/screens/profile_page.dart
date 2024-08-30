import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the Profile Page'),
            ElevatedButton(
              child: Text('Go to Home'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.HOME),
            ),
          ],
        ),
      ),
    );
  }
}
