import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class CalendarScreen extends StatelessWidget {
  final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 365)),
    onRangeSelected: (firstDate, secondDate) {},
    onDayTapped: (date) {},
    // readOnly: true,
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.monday,
    // initialFocusDate: DateTime(2023, 5),
    // initialDateSelected: DateTime(2022, 3, 15),
    // endDateSelected: DateTime(2022, 3, 20),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Screen'),
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: GNav(
          haptic: true,
          gap: 8,
          iconSize: 24,
          backgroundColor: Colors.black,
          color: Colors.grey, // unselected icon color
          activeColor: Colors.white, // selected icon and text color
          tabBackgroundColor:
              Colors.grey.shade800, // selected tab background color
          padding: EdgeInsets.all(12),
          onTabChange: (index) => print(index),
          tabs: const [
            GButton(icon: Icons.bar_chart_rounded, text: 'Statistics'),
            GButton(icon: Icons.calendar_today, text: 'Calendar'),
            GButton(icon: Icons.settings_rounded, text: 'Settings'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: ScrollableCleanCalendar(
              calendarController: calendarController,
              layout: Layout.DEFAULT,
              calendarCrossAxisSpacing: 0,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context,
                      '/moodLogging'); // Navigate to mood logging screen
                },
                child: Text('Go to Mood Logging'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
