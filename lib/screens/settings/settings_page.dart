import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the Settings Page'),
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