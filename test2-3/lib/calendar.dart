import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

// CalendarScreen widget
class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget
      appBar: AppBar(
        // App bar
        title: Text('Calendar Screen'), // Title text
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: GNav(
          haptic: true,
          // curve: Curves.easeOutExpo, // tab animation curves
          // duration: Duration(milliseconds: 200),
          onTabChange: (index) {
            print(index);
          },
          //appearance
          gap: 8,
          iconSize: 24,
          backgroundColor: Colors.black,
          color: Colors.grey, // unselected icon color
          activeColor: Colors.white, // selected icon and text color
          tabBackgroundColor:
              Colors.grey.shade800, // selected tab background color
          padding: EdgeInsets.all(12),
          tabs: const [
            GButton(icon: Icons.bar_chart_rounded, text: 'Statistics'),
            GButton(icon: Icons.calendar_month, text: 'Calendar'),
            GButton(icon: Icons.settings, text: 'Settings'),
          ],
        ),
      ),
      body: Center(
        // Centered body
        child: ElevatedButton(
          // Elevated button widget
          onPressed: () {
            Navigator.pushNamed(
                context, '/moodLogging'); // Navigate to mood logging screen
          },
          child: Text('Go to Mood Logging'), // Button text
        ),
      ),
    );
  }
}
