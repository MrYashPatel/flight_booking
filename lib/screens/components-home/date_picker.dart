import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerScreen extends StatefulWidget {
  final DateTime initialDeparture;
  final DateTime? initialReturn;
  final bool selectingReturn; // 👈 tells whether we are picking return

  const DatePickerScreen({
    super.key,
    required this.initialDeparture,
    this.initialReturn,
    this.selectingReturn = false,
  });

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  late DateTime focusedDay;
  late DateTime? selectedDeparture;
  late DateTime? selectedReturn;

  @override
  void initState() {
    super.initState();
    focusedDay = widget.selectingReturn
        ? (widget.initialReturn ?? widget.initialDeparture)
        : widget.initialDeparture;

    selectedDeparture = widget.initialDeparture;
    selectedReturn = widget.initialReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.selectingReturn ? 'Select Return Date' : 'Select Departure Date',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header with Departure and Return
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dateHeader(
                  title: 'Departure',
                  date: selectedDeparture != null
                      ? "${selectedDeparture!.day.toString().padLeft(2, '0')}/${selectedDeparture!.month.toString().padLeft(2, '0')}/${selectedDeparture!.year}"
                      : 'Select Date',
                  icon: Icons.calendar_today,
                  active: !widget.selectingReturn,
                ),
                _dateHeader(
                  title: 'Return',
                  date: selectedReturn != null
                      ? "${selectedReturn!.day.toString().padLeft(2, '0')}/${selectedReturn!.month.toString().padLeft(2, '0')}/${selectedReturn!.year}"
                      : '+ Add Return Date',
                  icon: Icons.add,
                  active: widget.selectingReturn,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 🔹 Calendar Widget
            Expanded(
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: focusedDay,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) {
                  if (widget.selectingReturn) {
                    return isSameDay(day, selectedReturn);
                  } else {
                    return isSameDay(day, selectedDeparture);
                  }
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  leftChevronIcon: const Icon(Icons.chevron_left),
                  rightChevronIcon: const Icon(Icons.chevron_right),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  weekendStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2), // ✅ Updated
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFFEC441E),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: GoogleFonts.inter(color: Colors.black87),
                  defaultTextStyle: GoogleFonts.inter(color: Colors.black),
                  outsideDaysVisible: false,
                ),
                onDaySelected: (selected, focused) {
                  setState(() {
                    focusedDay = focused;

                    if (widget.selectingReturn) {
                      // prevent selecting return before departure
                      if (selected.isBefore(selectedDeparture!)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Return date cannot be before departure date'),
                          ),
                        );
                      } else {
                        selectedReturn = selected;
                      }
                    } else {
                      selectedDeparture = selected;
                      // reset return if it's now invalid
                      if (selectedReturn != null &&
                          selectedReturn!.isBefore(selected)) {
                        selectedReturn = null;
                      }
                    }
                  });
                },
                onPageChanged: (focused) => focusedDay = focused,
              ),
            ),

            // 🔹 Select Button
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC441E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      'departure': selectedDeparture,
                      'return': selectedReturn,
                    });
                  },
                  child: Text(
                    'Select',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateHeader({
    required String title,
    required String date,
    required IconData icon,
    required bool active,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: active ? const Color(0xFFEC441E) : Colors.grey.shade700,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(icon,
                size: 16.sp,
                color: active ? const Color(0xFFEC441E) : Colors.black54),
            SizedBox(width: 6.w),
            Text(
              date,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? Colors.black : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
