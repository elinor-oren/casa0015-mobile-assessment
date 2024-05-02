import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HealthSessionData {
  DateTime? selectedDate;
  int? moodLevel;
  double? sleepHours;
  num? bpmValue;
  // Named parameters can't start with an underscore
  //so I'm not using the variable name (_bpmValue)

  HealthSessionData._();

  static final HealthSessionData _instance = HealthSessionData._internal();
  factory HealthSessionData() => _instance;
  HealthSessionData._internal();

  void setSleepDuration(int hours, int minutes) {
    sleepHours = hours +
        minutes / 60.0; // Converts hours and minutes to a decimal hour format
  }

  // Method to convert selectedDate to Timestamp
  Timestamp? getTimestampFromDate(DateTime? date) {
    if (date != null) {
      return Timestamp.fromDate(date);
    }
    return null;
  }

  void _submitDataToFirestore() {
    HealthSessionData sessionData = HealthSessionData();

    // Convert selectedDate to Timestamp ttype
    Timestamp? timestamp =
        sessionData.getTimestampFromDate(sessionData.selectedDate);

    FirebaseFirestore.instance.collection('health_session').add({
      'selectedDate': timestamp, // Use converted Timestamp
      'moodLevel': moodLevel,
      'sleepDuration': sleepHours,
      'bpmValue': bpmValue,
    }).then((value) {
      print('Data submitted to Firestore');
    }).catchError((error) {
      print('Failed to submit data: $error');
    });
  }
}
