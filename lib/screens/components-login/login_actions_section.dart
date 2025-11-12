import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../otp_verification_screen.dart';

class LoginActionsSection extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onLoginPressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onCreateAccount;

  const LoginActionsSection({
    super.key,
    required this.isLoading,
    required this.onLoginPressed,
    this.onGooglePressed,
    this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ensures no extra vertical space
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ⚙️ Reduced spacing between checkbox & button
        SizedBox(height: 2.h),

        // 🔹 Login Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero, // ⛔ no internal padding
              backgroundColor: const Color(0xFFEC441E),
              elevation: 0, // ⛔ optional: removes button shadow if unwanted
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OtpVerificationScreen()),
              );
            },
            child: isLoading
                ? const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
                : Text(
              'Login',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),


        SizedBox(height: 28.h),

        // 🔹 Divider ("or continue with")
        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.grey.shade300, thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'or continue with',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: Colors.grey.shade300, thickness: 1),
            ),
          ],
        ),

        SizedBox(height: 24.h),

        // 🔹 Continue with Google Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              side: BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: onGooglePressed,
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Colors.red,
              size: 22,
            ),
            label: Text(
              'Continue with Google',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SizedBox(height: 28.h),

        // 🔹 Create account link (bottom)
        Center(
          child: GestureDetector(
            onTap: onCreateAccount,
            child: Text(
              'Create an account',
              style: GoogleFonts.inter(
                color: const Color(0xFFEC441E),
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
