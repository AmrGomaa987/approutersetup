// Generated code - do not modify by hand

import 'package:approutersetup/screens/home_page.dart';
import 'package:approutersetup/screens/profile_page.dart';
import 'package:approutersetup/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';


class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.HOME:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case AppRoutes.PROFILE:
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
        );
      case AppRoutes.SETTINGS:
        return MaterialPageRoute(
          builder: (_) => SettingsPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text('Not Found')),
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
