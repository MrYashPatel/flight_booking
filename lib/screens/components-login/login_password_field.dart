import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgot_password_screen.dart'; // 👈 Make sure this path is correct

class LoginPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool keepSignedIn;
  final ValueChanged<bool> onCheckboxChanged;

  const LoginPasswordField({
    super.key,
    required this.controller,
    required this.keepSignedIn,
    required this.onCheckboxChanged,
  });

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Label + Forgot Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                // ✅ Navigate to Forgot Password Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.inter(
                  color: const Color(0xFFEC441E),
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // 🔹 Password Field
        TextField(
          controller: widget.controller,
          obscureText: !isPasswordVisible,
          style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey.shade400,
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
                size: 20.sp,
              ),
              onPressed: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xFFEC441E),
                width: 1.5,
              ),
            ),
          ),
        ),

        SizedBox(height: 8.h),

        // 🔹 Keep Me Signed In Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: widget.keepSignedIn,
              onChanged: (val) => widget.onCheckboxChanged(val ?? false),
              activeColor: const Color(0xFFEC441E),
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              side: const BorderSide(
                color: Colors.black,
                width: 1.2,
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              'Keep me signed in',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
