import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FlightApp());
}

class FlightApp extends StatelessWidget {
  const FlightApp({super.key});

  // 🧠 Check if user is logged in or not
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flight Booking',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          // 👇 Start with SplashScreen first
          home: SplashWrapper(checkLoginStatus: _checkLoginStatus),
        );
      },
    );
  }
}

/// This wrapper shows the splash screen for 3 seconds,
/// then decides whether to go to HomePage or LoginScreen.
class SplashWrapper extends StatefulWidget {
  final Future<bool> Function() checkLoginStatus;
  const SplashWrapper({super.key, required this.checkLoginStatus});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Wait for splash screen duration
    await Future.delayed(const Duration(seconds: 3));

    // Check login status
    final isLoggedIn = await widget.checkLoginStatus();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        isLoggedIn ? const HomePage() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(); // 👈 Your designed splash screen widget
  }
}
