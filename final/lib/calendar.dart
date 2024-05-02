import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:test2/ppg.dart';
import 'package:test2/moodLogging.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PreferencesService {
  Future<void> saveMoodColor(DateTime date, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    // Store color as an integer
    await prefs.setInt(date.toIso8601String(), color.value);
  }

  Future<Color?> loadMoodColor(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    // Load the color value as an integer
    int? colorValue = prefs.getInt(date.toIso8601String());
    if (colorValue != null) {
      return Color(colorValue);
    }
    return null;
  }
}


class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? selectedDate; // Tracks the selected date
  Map<DateTime, Color> moodColors = {}; // Stores the mood color for each date
  int selectedIndex = 1; // Sets "Calendar" tab as default
    final preferencesService = PreferencesService();

@override
  void initState() {
    super.initState();
    _loadColors();
  }
Future<void> _loadColors() async {
  DateTime now = DateTime.now();
  DateTime startOfMonth = DateTime(now.year, now.month, 1);
  int lastDay = DateUtils.getDaysInMonth(now.year, now.month);
  DateTime endOfMonth = DateTime(now.year, now.month, lastDay);

  for (DateTime day = startOfMonth;
      day.isBefore(endOfMonth.add(Duration(days: 1)));
      day = day.add(Duration(days: 1))) {
    Color? color = await preferencesService.loadMoodColor(day);
    if (color != null) {
      setState(() {
        moodColors[day] = color;
      });
    }
  }
}



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
          selectedIndex: selectedIndex,
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
              maxDate: DateTime.now(),
              monthBuilder: (context, month, year) =>
                  buildMonthHeader(context, month, year),
              dayBuilder: (context, date) => buildDayTile(context, date),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  //if a date is selected (aka not null), push the MoodLoggingScreen onto the navigation stack
                  if (selectedDate != null) {
                    // Update the health_session_data.dart
                    HealthSessionData().selectedDate = selectedDate;
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
                            color; // Updates the color map
                      });
                              await preferencesService.saveMoodColor(selectedDate!, color);

                      // After setting data in the calendar screen
                      HealthSessionData().printData();

                      //Navigates to the sleep screen after updating colooor
                      Navigator.pushNamed(context, '/sleepLogging');
                    }
                  }
                },
                child: Text('Go to Mood Logging'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDayTile(BuildContext context, DateTime date) {
    Color bgColor =
        moodColors.containsKey(date) ? moodColors[date]! : Colors.grey[850]!;
    Color textColor = moodColors.containsKey(date)
        ? darken(moodColors[date]!, 0.3)
        : Colors.grey[500]!;

    return GestureDetector(
      onTap: () => setState(() {
        HapticFeedback.lightImpact();
        selectedDate = date; // Update the selected date on tap
      }),
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selectedDate == date ? Colors.blue : Colors.transparent,
              width: 2,
            )),
        child: Center(
          child: Text(
            DateFormat('d').format(date),
            style: TextStyle(color: textColor),
          ),
        ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map(weekText)
                .toList(),
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

//ChatGPT wrote this function for me
  // Function to darken a color by [amount] (0-1)
  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
