import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class MoodLoggingScreen extends StatefulWidget {
  final DateTime selectedDate; // Add a parameter to accept the selected date

  MoodLoggingScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _MoodLoggingScreenState createState() => _MoodLoggingScreenState();
}

class _MoodLoggingScreenState extends State<MoodLoggingScreen> {
  int? selectedMoodIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141925),
      appBar: AppBar(
        title: Text('Mood Logging Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(10, (index) {
                  int moodLevel = 10 - index;
                  return MoodRectangle(
                    moodLevel: moodLevel,
                    isSelected: selectedMoodIndex == index - 1,
                    onTap: () {
                      setState(() {
                        selectedMoodIndex = index;
                      });
                    },
                  );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // On pressing the button, pop with selected mood color
                if (selectedMoodIndex != null) {
                  Navigator.pop(
                      context,
                      _getColorForMood(
                          selectedMoodIndex!)); // Pass the color back
                }
              },
              child: Text('Go to Sleep Logging'),
            ),
          ),
        ],
      ),
    );
  }
}

class MoodRectangle extends StatefulWidget {
  final int moodLevel;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodRectangle({
    Key? key,
    required this.moodLevel,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _MoodRectangleState createState() => _MoodRectangleState();
}

class _MoodRectangleState extends State<MoodRectangle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: Container(
        width: 150,
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: widget.isSelected
                ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                : ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              alignment: Alignment.center,
              color: _getColorForMood(widget.moodLevel)
                  .withOpacity(widget.isSelected ? 1.0 : 0.6),
              child: Text(
                widget.moodLevel.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _getColorForMood(int moodLevel) {
  switch (moodLevel) {
    case 1:
      return Color(0xFF005672); // Dark Blue
    case 2:
    case 3:
      return Color(0xFF97BFC3); // Light Blue
    case 4:
    case 5:
    case 6:
      return Color.fromARGB(255, 234, 223, 181); // Beige
    case 7:
    case 8:
    case 9:
      return Color.fromARGB(255, 248, 121, 99); // Orange
    case 10:
      return Color(0xFFC9442E); // Dark Orange
    default:
      return Colors.grey;
  }
}
