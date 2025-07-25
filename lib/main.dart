import 'package:flutter/material.dart';
import 'package:vikincode/screens/Notification.dart';
import 'package:vikincode/widgets/custom_navigation_bar.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/Map.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cabapp',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/navigationbar': (context) => const NavigationBarPage(),
        '/dashboard': (context) => const DashboardScreen(),
        '/map': (context) => DarkMapScreen(),
        '/notification': (context) => NotificationApp(),
      },
    );
  }
}
