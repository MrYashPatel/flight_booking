import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'date_picker.dart'; // 👈 Make sure this file exists

class HomeFlightForm extends StatefulWidget {
  final int tripType; // 0 = One Way, 1 = Round, 2 = Multicity

  const HomeFlightForm({super.key, required this.tripType});

  @override
  State<HomeFlightForm> createState() => _HomeFlightFormState();
}

class _HomeFlightFormState extends State<HomeFlightForm>
    with SingleTickerProviderStateMixin {
  String fromCity = 'Delhi';
  String fromAirport = 'Indira Gandhi Intl Airport';
  String toCity = 'Kolkata';
  String toAirport = 'Subhash Chandra Intl Airport';

  // ✅ Default today's date
  String departureDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String? returnDate;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _swapLocations() {
    _controller.forward(from: 0);
    setState(() {
      final tempCity = fromCity;
      final tempAirport = fromAirport;
      fromCity = toCity;
      fromAirport = toAirport;
      toCity = tempCity;
      toAirport = tempAirport;
    });
  }

  /// ✅ Opens DatePicker for either departure or return date
  Future<void> _openDatePicker(bool isDeparture) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DatePickerScreen(
          initialDeparture: DateFormat('dd/MM/yyyy').parse(departureDate),
          initialReturn: returnDate != null
              ? DateFormat('dd/MM/yyyy').parse(returnDate!)
              : null,
          selectingReturn: !isDeparture,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        // Set departure date
        if (isDeparture && result['departure'] != null) {
          departureDate =
          "${result['departure'].day.toString().padLeft(2, '0')}/${result['departure'].month.toString().padLeft(2, '0')}/${result['departure'].year}";

          // reset return if it becomes invalid
          if (returnDate != null) {
            final dep = result['departure'];
            final ret = DateFormat('dd/MM/yyyy').parse(returnDate!);
            if (ret.isBefore(dep)) returnDate = null;
          }
        }

        // Set return date
        if (!isDeparture && result['return'] != null) {
          final dep = DateFormat('dd/MM/yyyy').parse(departureDate);
          final ret = result['return'];

          if (ret.isBefore(dep)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Return date cannot be before departure date'),
              ),
            );
          } else {
            returnDate =
            "${ret.day.toString().padLeft(2, '0')}/${ret.month.toString().padLeft(2, '0')}/${ret.year}";
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isRoundTrip = widget.tripType == 1;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legendField(label: 'From', city: fromCity, airport: fromAirport),
              SizedBox(height: 20.h),
              _legendField(label: 'To', city: toCity, airport: toAirport),
              SizedBox(height: 20.h),

              // 🗓 Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _openDatePicker(true),
                    child: _dateField(
                      Icons.calendar_today,
                      'Departure',
                      departureDate,
                    ),
                  ),
                  GestureDetector(
                    onTap: isRoundTrip ? () => _openDatePicker(false) : null,
                    child: Opacity(
                      opacity: isRoundTrip ? 1 : 0.4,
                      child: _dateField(
                        Icons.add,
                        'Return',
                        isRoundTrip
                            ? (returnDate ?? '+ Add Return Date')
                            : 'One-way',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _smallField('Traveller', '1 Adult'),
                  _smallField('Class', 'Economy'),
                ],
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC441E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Search Flights',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 🔁 Swap button
          Positioned(
            right: 16.w,
            top: 40.h,
            child: GestureDetector(
              onTap: _swapLocations,
              child: RotationTransition(
                turns: _animation,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.swap_vert,
                    color: const Color(0xFFEC441E),
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✈️ City/Airport input
  Widget _legendField({
    required String label,
    required String city,
    required String airport,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                airport,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 12.w,
          top: -8.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            color: Colors.white,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFFEC441E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 📅 Date Field
  Widget _dateField(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 18.sp),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 👤 Traveller & Class
  Widget _smallField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
