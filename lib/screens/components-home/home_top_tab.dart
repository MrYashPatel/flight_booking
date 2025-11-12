import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTopTab extends StatefulWidget {
  final Function(int) onTabChanged; // 👈 callback to parent

  const HomeTopTab({super.key, required this.onTabChanged});

  @override
  State<HomeTopTab> createState() => _HomeTopTabState();
}

class _HomeTopTabState extends State<HomeTopTab> {
  int selectedIndex = 0;
  final List<String> tabs = ['One way', 'Round', 'Multicity'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          int idx = entry.key;
          String label = entry.value;
          bool isSelected = selectedIndex == idx;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => selectedIndex = idx);
                widget.onTabChanged(idx); // 👈 notify parent
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEC441E) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
