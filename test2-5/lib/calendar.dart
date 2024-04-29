import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:test2/moodLogging.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? selectedDate; // Tracks the selected date
  Map<DateTime, Color> moodColors = {}; // Stores the mood color for each date

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
          color: Colors.grey,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
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
            child: PagedVerticalCalendar(
              startWeekWithSunday: true,
              minDate: DateTime(2000),
              maxDate: DateTime.now(), // Prevents future dates selection
              monthBuilder: (context, month, year) {
                return buildMonthHeader(context, month, year);
              },
              dayBuilder: (context, date) {
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedDate = date; // Update the selected date on tap
                  }),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: moodColors[date] ?? Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedDate == date
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(date),
                          style: TextStyle(color: Colors.white),
                        ),
                        Divider(color: Colors.grey, thickness: 1),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: ElevatedButton(
              onPressed: () async {
                if (selectedDate != null) {
                  final color = await Navigator.push<Color>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MoodLoggingScreen(selectedDate: selectedDate!),
                    ),
                  );
                  if (color != null) {
                    setState(() {
                      moodColors[selectedDate!] =
                          color; // Update the mood color map
                    });
                    // After updating the mood color, navigate to the sleep logging screen
                    Navigator.pushNamed(context, '/sleepLogging');
                  }
                } else {
                  print("No date selected!");
                }
              },
              child: Text('Go to Mood Logging'),
            )),
          ),
        ],
      ),
    );
  }

  Widget buildMonthHeader(BuildContext context, int month, int year) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Text(
            DateFormat('MMMM yyyy').format(DateTime(year, month)),
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                7,
                (index) => weekText(
                    ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'][index])),
          ),
        ),
      ],
    );
  }

  Widget weekText(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey, fontSize: 10),
      ),
    );
  }
}
