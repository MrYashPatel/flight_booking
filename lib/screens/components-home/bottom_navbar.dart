import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> items = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.book_online, 'label': 'Booking'},
    {'icon': Icons.local_offer, 'label': 'Offer'},
    {'icon': Icons.mail_outline, 'label': 'Inbox'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFEC441E), // 🟠 Orange background
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      elevation: 10,

      // ⚙️ Colors
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70, // softer white for unselected

      selectedLabelStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w800, // bolder selected text
        fontSize: 13,
        color: Colors.white,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 13,
        color: Colors.white70,
      ),

      onTap: (index) => setState(() => currentIndex = index),

      items: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        final bool isSelected = index == currentIndex;

        return BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              item['icon'],
              size: isSelected ? 28 : 24, // 🔹 Bigger icon when selected
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
          label: item['label'],
        );
      }).toList(),
    );
  }
}
