import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class AppointmentService {
  // In future, this will be replaced with API calls
  Future<List<Appointment>> fetchAppointments() async {
    // Simulating API call delay
    await Future.delayed(Duration(milliseconds: 500));

    return [
      Appointment(
        startTime: DateTime(2024, 5, 1, 9, 0),
        endTime: DateTime(2024, 5, 1, 10,0 ),
        subject: 'Терентьев М. В.',
        color: Colors.green,
        resourceIds: ['chair1'], // Assigned to Chair #1
      ),
      Appointment(
        startTime: DateTime(2024, 5, 1, 10, 0),
        endTime: DateTime(2024, 5, 1, 11,0 ),
        subject: 'Терентьев М. В.',
        color: Colors.green,
        resourceIds: ['chair1'], // Assigned to Chair #1
      ),
      Appointment(
        startTime: DateTime(2024, 5, 1, 10, 0),
        endTime: DateTime(2024, 5, 1, 18, 15),
        subject: 'Пискарев А. В.',
        color: Colors.pink,
        resourceIds: ['chair2'], // Assigned to Chair #2
      ),
      Appointment(
        startTime: DateTime(2024, 5, 1, 9, 30),
        endTime: DateTime(2024, 5, 1, 10, 0),
        subject: 'Кузьмина Е. Н.',
        color: Colors.purple,
        resourceIds: ['chair3'], // Assigned to Chair #3
      ),

      Appointment(
        startTime: DateTime(2024, 5, 1, 9, 0),
        endTime: DateTime(2024, 5, 1, 9, 30),
        subject: 'Теренть М. В.',
        color: Colors.green,
        resourceIds: ['chair4'], // Assigned to Chair #1
      ),
      Appointment(
        startTime: DateTime(2024, 5, 2, 10, 0),
        endTime: DateTime(2024, 5, 2, 11, 0),
        subject: 'Пискарев А. В.',
        color: Colors.pink,
        resourceIds: ['chair2'],
      ),
      Appointment(
        startTime: DateTime(2024, 5, 3, 9, 0),
        endTime: DateTime(2024, 5, 3, 10,0 ),
        subject: 'Терентьев М. В.',
        color: Colors.green,
        resourceIds: ['chair1'], // Assigned to Chair #1
      ),
      Appointment(
        startTime: DateTime(2024, 5, 3, 10, 0),
        endTime: DateTime(2024, 5, 3, 11,0 ),
        subject: 'Терентьев М. В.',
        color: Colors.green,
        resourceIds: ['chair1'], // Assigned to Chair #1
      ),
      Appointment(
        startTime: DateTime(2024, 5, 3, 10, 0),
        endTime: DateTime(2024, 5, 3, 10, 15),
        subject: 'Пискарев А. В.',
        color: Colors.pink,
        resourceIds: ['chair2'], // Assigned to Chair #2
      ),


    ];
  }

  Future<List<CalendarResource>> fetchChairs() async {
    // Simulating API call delay
    await Future.delayed(Duration(milliseconds: 500));

    return [
      CalendarResource(displayName: "Кресло #1", id: "chair1", color: Colors.green),
      CalendarResource(displayName: "Кресло #2", id: "chair2", color: Colors.pink),
      CalendarResource(displayName: "Кресло #3", id: "chair3", color: Colors.purple),
      CalendarResource(displayName: "Кресло #4", id: "chair4", color: Colors.blue),
    ];
  }

  Future<Map<String, Map<String, List<String>>>> fetchChairSchedules() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulating API delay

    return {
      "2024-05-01": {
        "chair1": ["08:00", "16:00"], // Chair 1 works from 8 AM to 4 PM
        "chair2": ["10:00", "18:00"], // Chair 2 works from 10 AM to 6 PM
      },
      "2024-05-02": {
        "chair1": ["09:00", "15:00"], // Different schedule on another day
        "chair3": ["11:00", "17:00"], // Chair 3 works only on this day
      },
    };
  }


}