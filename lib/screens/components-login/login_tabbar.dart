import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginTabBar extends StatelessWidget {
  final TabController tabController;
  const LoginTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: tabController,
          isScrollable: false,
          labelColor: const Color(0xFFEC441E),
          unselectedLabelColor: Colors.grey.shade700,
          labelStyle: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          indicatorColor: const Color(0xFFEC441E),
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: 'Email'),
            Tab(text: 'Phone Number'),
          ],
        ),
        Container(
          height: 1,
          color: Colors.grey.shade300,
          width: double.infinity,
        ),
      ],
    );
  }
}
