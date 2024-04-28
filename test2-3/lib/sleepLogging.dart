import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Ensure this import is present for intl
import 'package:intl/intl.dart' as intl; // For number formatting
import 'package:progressive_time_picker/progressive_time_picker.dart'; // Ensure this import is present for the TimePicker

class SleepLoggingScreen extends StatefulWidget {
  @override
  _SleepLoggingScreenState createState() => _SleepLoggingScreenState();
}

class _SleepLoggingScreenState extends State<SleepLoggingScreen> {
  ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;
  ClockIncrementTimeFormat _clockIncrementTimeFormat =
      ClockIncrementTimeFormat.fiveMin;

  PickedTime _inBedTime = PickedTime(h: 0, m: 0);
  PickedTime _outBedTime = PickedTime(h: 8, m: 0);
  PickedTime _intervalBedTime = PickedTime(h: 0, m: 0);

  double _sleepGoal = 8.0;
  bool _isSleepGoal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141925),
      appBar: AppBar(
        title: const Center(child: Text("Sleep Logger")),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TimePicker(
            initTime: _inBedTime,
            endTime: _outBedTime,
            height: 260.0,
            width: 260.0,
            onSelectionChange: (start, end, _) => _updateLabels(start, end),
            onSelectionEnd: (start, end, _) => _updateLabels(start, end),
            primarySectors: _clockTimeFormat.value,
            secondarySectors: _clockTimeFormat.value * 2,
            decoration: TimePickerDecoration(
              baseColor: const Color(0xFF1F2633),
              pickerBaseCirclePadding: 15.0,
              sweepDecoration: TimePickerSweepDecoration(
                pickerStrokeWidth: 30.0,
                pickerColor:
                    _isSleepGoal ? const Color(0xFF3CDAF7) : Colors.white,
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
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/ppg'); // Navigate to PPG screen
            },
            child: Text('Go to PPG'),
          ),
          Container(
            width: 300.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1F2633),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _isSleepGoal
                    ? "More sleep than recommended"
                    : 'below Sleep Goal (<=8) 😴',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateLabels(PickedTime init, PickedTime end) {
    setState(() {
      _inBedTime = init;
      _outBedTime = end;
      // Add more logic here if needed to calculate intervals or validate the sleep goal
    });
  }
}
