import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'airport_service.dart';
import 'date_picker.dart';

class HomeFlightForm extends StatefulWidget {
  final int tripType; // 0 = One Way, 1 = Round, 2 = Multicity

  const HomeFlightForm({super.key, required this.tripType});

  @override
  State<HomeFlightForm> createState() => _HomeFlightFormState();
}

class _HomeFlightFormState extends State<HomeFlightForm>
    with SingleTickerProviderStateMixin {
  // ✈️ Airport fields
  late String fromCity, fromAirport, toCity, toAirport;

  // 📅 Dates
  String departureDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String? returnDate;

  // 👤 Travellers & Class
  int travellerCount = 1;
  String travelClass = 'Economy';
  final List<String> travelClasses = [
    'Economy',
    'Premium Economy',
    'Business',
    'First'
  ];

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

  /// Opens DatePicker for either departure or return date
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
        if (isDeparture && result['departure'] != null) {
          departureDate =
              DateFormat('dd/MM/yyyy').format(result['departure']);
          if (returnDate != null) {
            final dep = result['departure'];
            final ret = DateFormat('dd/MM/yyyy').parse(returnDate!);
            if (ret.isBefore(dep)) returnDate = null;
          }
        }

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
            returnDate = DateFormat('dd/MM/yyyy').format(ret);
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
              _legendField(label: 'From', isFromField: true),
              SizedBox(height: 20.h),
              _legendField(label: 'To', isFromField: false),
              SizedBox(height: 20.h),

              // 🗓 Date selection
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

              // 👤 Traveller and Class selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _travellerSelector(),
                  _classSelector(),
                ],
              ),
              SizedBox(height: 24.h),

              // 🔍 Search button
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Search Parameters'),
                        content: Text(
                          'From: $fromCity ($fromAirport)\n'
                              'To: $toCity ($toAirport)\n'
                              'Departure: $departureDate\n'
                              '${returnDate != null ? "Return: $returnDate\n" : ""}'
                              'Travellers: $travellerCount\n'
                              'Class: $travelClass',
                        ),
                      ),
                    );
                  },
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

          // 🔁 Swap Button
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

  // 🧭 Editable Airport Field
  Widget _legendField({
    required String label,
    required bool isFromField,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TypeAheadField<Map<String, String>>(
            suggestionsCallback: (pattern) async {
              return await AirportService.fetchAirports(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.orange.shade50,
                  child: Text(
                    suggestion['iata']!.isNotEmpty
                        ? suggestion['iata']!
                        : suggestion['icao'] ?? '-',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFEC441E),
                    ),
                  ),
                ),
                title: Text(
                  suggestion['name']!,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "${suggestion['city']} • ${suggestion['country']}",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            },
            onSelected: (suggestion) {
              setState(() {
                if (isFromField) {
                  fromCity = suggestion['city']!;
                  fromAirport =
                  "${suggestion['name']} (${suggestion['iata'] ?? suggestion['icao']})";
                } else {
                  toCity = suggestion['city']!;
                  toAirport =
                  "${suggestion['name']} (${suggestion['iata'] ?? suggestion['icao']})";
                }
              });
            },
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: isFromField
                      ? 'Enter departure city or airport'
                      : 'Enter destination city or airport',
                  border: InputBorder.none,
                ),
              );
            },
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

  // 👤 Traveller Selector (Bottom Sheet)
  Widget _travellerSelector() {
    return GestureDetector(
      onTap: _showTravellerSelector,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Traveller',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$travellerCount Adult${travellerCount > 1 ? 's' : ''}',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 🏷️ Class Selector (Bottom Sheet)
  Widget _classSelector() {
    return GestureDetector(
      onTap: _showClassSelector,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Class',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            travelClass,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 📋 Bottom Sheet for Traveller
  void _showTravellerSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          height: 300.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Travellers',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    final count = index + 1;
                    return ListTile(
                      title: Text(
                        '$count Adult${count > 1 ? 's' : ''}',
                        style: GoogleFonts.inter(fontSize: 14.sp),
                      ),
                      trailing: travellerCount == count
                          ? const Icon(Icons.check_circle,
                          color: Color(0xFFEC441E))
                          : null,
                      onTap: () {
                        setState(() => travellerCount = count);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ✈️ Bottom Sheet for Class Selection
  void _showClassSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          height: 300.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Travel Class',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: travelClasses.length,
                  itemBuilder: (context, index) {
                    final cls = travelClasses[index];
                    return ListTile(
                      title: Text(cls, style: GoogleFonts.inter(fontSize: 14.sp)),
                      trailing: travelClass == cls
                          ? const Icon(Icons.check_circle,
                          color: Color(0xFFEC441E))
                          : null,
                      onTap: () {
                        setState(() => travelClass = cls);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
}
