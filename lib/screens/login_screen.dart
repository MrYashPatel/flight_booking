import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components-login/login_header.dart';
import 'components-login/login_tabbar.dart';
import 'components-login/login_textfield.dart';
import 'components-login/login_password_field.dart';
import 'components-login/login_actions_section.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool keepSignedIn = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);

    // Simulate login delay
    await Future.delayed(const Duration(seconds: 2));

    // Save login status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    if (!mounted) return;
    setState(() => isLoading = false);

    // Navigate to Home Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double tabViewHeight = 220.h; // bounded height to prevent layout errors

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1️⃣ Header
              const LoginHeader(),
              SizedBox(height: 32.h),

              // 2️⃣ TabBar (Email / Phone)
              LoginTabBar(tabController: tabController),

              // 🔹 Add more spacing before "Email Address"
              SizedBox(height: 28.h),

              // 3️⃣ Tab Content (Email or Phone Login)
              SizedBox(
                height: tabViewHeight,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    // 🔹 Email Tab
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🧩 Spacing before Email Address field
                        LoginTextField(
                          label: 'Email Address',
                          hint: 'Enter your email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 12.h),
                        LoginPasswordField(
                          controller: passwordController,
                          keepSignedIn: keepSignedIn,
                          onCheckboxChanged: (val) {
                            setState(() => keepSignedIn = val);
                          },
                        ),
                      ],
                    ),

                    // 🔹 Phone Tab
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🧩 Spacing before Mobile Number field
                        LoginTextField(
                          label: 'Mobile Number',
                          hint: 'Enter your phone number',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 12.h),
                        LoginPasswordField(
                          controller: passwordController,
                          keepSignedIn: keepSignedIn,
                          onCheckboxChanged: (val) {
                            setState(() => keepSignedIn = val);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 6.h),

              // 4️⃣ Combined Actions Section (Login + Google + Create Account)
              LoginActionsSection(
                isLoading: isLoading,
                onLoginPressed: _handleLogin,
                onGooglePressed: () {
                  // TODO: Implement Google Sign-In
                },
                onCreateAccount: () {
                  // TODO: Navigate to registration page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
