import 'package:flutter/material.dart';
import 'package:vikincode/main.dart';
import 'package:vikincode/screens/Notification.dart';
import 'package:vikincode/screens/dashboard_screen.dart';
import 'package:vikincode/screens/profile_screen.dart';
import 'package:vikincode/screens/Map.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    DarkMapScreen(),
    NotificationApp(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final isActive = _currentIndex == index;
            final icons = [
              Icons.home_outlined,
              Icons.navigation_outlined,
              Icons.notifications_outlined,
              Icons.person_outline,
            ];

            return GestureDetector(
              onTap: () {
                setState(() => _currentIndex = index);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[index],
                    color: isActive ? Colors.white : Colors.white24,
                    size: 26,
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
