import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:progressive_time_picker/progressive_time_picker.dart';

class SleepLoggingScreen extends StatefulWidget {
  @override
  _SleepLoggingScreenState createState() => _SleepLoggingScreenState();
}

class _SleepLoggingScreenState extends State<SleepLoggingScreen> {
  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  ClockIncrementTimeFormat _clockIncrementTimeFormat =
      ClockIncrementTimeFormat.fiveMin;

  PickedTime _inBedTime =
      PickedTime(h: 22, m: 0); // Default bedtime at 10:00 PM
  PickedTime _outBedTime =
      PickedTime(h: 6, m: 0); // Default wake-up time at 6:00 AM
  PickedTime _intervalBedTime =
      PickedTime(h: 0, m: 0); // Initialized with default values

  double _sleepGoal = 8.0;
  double _tolerance =
      1.0; //I don't feel like updating sleep goal into two variables
  bool _isSleepGoal = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF141925),
      appBar: AppBar(
        title: const Text("Sleep Logger"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _timeWidget('Bedtime', _inBedTime),
                  _timeWidget('Wake Up', _outBedTime),
                ],
              ),
              SizedBox(height: screenHeight * 0.02), // Adds space between items
              TimePicker(
                initTime: _inBedTime,
                endTime: _outBedTime,
                height: screenHeight * 0.4, // Responsive based on screen height
                width: screenWidth * 0.8, // Responsive based on screen width
                onSelectionChange: (start, end, _) => _updateLabels(start, end),
                onSelectionEnd: (start, end, _) => _updateLabels(start, end),
                primarySectors: _clockTimeFormat.value,
                secondarySectors: _clockTimeFormat.value * 2,
                decoration: buildTimePickerDecoration(),
              ),
              Container(
                width: screenWidth * 0.8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2633),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenHeight * 0.018),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors
                              .white), // Default text style for non-highlighted text
                      children: <TextSpan>[
                        TextSpan(
                            text: "You slept ",
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(
                          text: "${_intervalBedTime.h}", // Bold and larger font
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        TextSpan(
                          text: " hrs ",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: "${_intervalBedTime.m}", // Bold and larger font
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        TextSpan(
                          text: " mins",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/ppg'),
                child: Text('Go to PPG'),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  TimePickerDecoration buildTimePickerDecoration() {
    return TimePickerDecoration(
      baseColor: const Color(0xFF1F2633),
      pickerBaseCirclePadding: 15.0,
      sweepDecoration: TimePickerSweepDecoration(
        pickerStrokeWidth: 30.0,
        pickerColor: _isSleepGoal ? const Color(0xFF3CDAF7) : Colors.white,
        showConnector: true,
      ),
      initHandlerDecoration: TimePickerHandlerDecoration(
        color: const Color(0xFF141925),
        shape: BoxShape.circle,
        radius: 12.0,
      ),
      endHandlerDecoration: TimePickerHandlerDecoration(
        color: const Color(0xFF141925),
        shape: BoxShape.circle,
        radius: 12.0,
      ),
      primarySectorsDecoration: TimePickerSectorDecoration(
        color: Colors.white,
        width: 1.0,
        size: 4.0,
        radiusPadding: 25.0,
      ),
      secondarySectorsDecoration: TimePickerSectorDecoration(
        color: const Color(0xFF3CDAF7),
        width: 1.0,
        size: 2.0,
        radiusPadding: 25.0,
      ),
      clockNumberDecoration: TimePickerClockNumberDecoration(
        defaultTextColor: Colors.white,
        defaultFontSize: 12.0,
        scaleFactor: 2.0,
        showNumberIndicators: true,
        clockTimeFormat: _clockTimeFormat,
      ),
    );
  }

  Widget _timeWidget(String title, PickedTime time) {
    // Determine AM/PM suffix based on the hour
    String amPm = (time.h >= 12 && time.h < 24) ? 'PM' : 'AM';
    // Adjust hour for 12-hour format display
    int hour12 = time.h % 12;
    hour12 = hour12 == 0 ? 12 : hour12; // Convert 0 hour to 12 for readability

    return Container(
      width: 150.0,
      margin: EdgeInsets.only(top: 25.0), // Adds spacing on top of the widget
      decoration: BoxDecoration(
        color: Color(0xFF1F2633),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            Text(
              amPm, // AM/PM indicator
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 14, // Smaller font size for AM/PM
              ),
            ),
            SizedBox(height: 2), // Spacing between AM/PM and the time
            Text(
              '${intl.NumberFormat('00').format(hour12)}:${intl.NumberFormat('00').format(time.m)}', // Time
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
                height:
                    3), // Spacing between the time and the bedtime wakeup text
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateLabels(PickedTime init, PickedTime end) {
    setState(() {
      _inBedTime = init;
      _outBedTime = end;
      _calculateSleepDuration(); // Recalculates whenever the time selection changes
    });
  }

  void _calculateSleepDuration() {
    int startMinutes = _inBedTime.h * 60 + _inBedTime.m;
    int endMinutes = _outBedTime.h * 60 + _outBedTime.m;
    if (endMinutes < startMinutes) {
      endMinutes += 1440; // Handles next day wake up
    }
    int durationMinutes = endMinutes - startMinutes;
    double durationHours = durationMinutes / 60.0;

    _intervalBedTime =
        PickedTime(h: durationMinutes ~/ 60, m: durationMinutes % 60);
    _isSleepGoal = (durationHours >= (_sleepGoal - _tolerance) &&
        durationHours <=
            (_sleepGoal +
                _tolerance)); // Includes a ± 1 to accomodate a range of 7-9 hours
  }
}
