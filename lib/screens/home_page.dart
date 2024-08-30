import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Page!'),
            ElevatedButton(
              child: Text('Go to Profile'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.PROFILE),
            ),
            ElevatedButton(
              child: Text('Go to Settings'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.SETTINGS),
            ),
          ],
        ),
      ),
    );
  }
}
