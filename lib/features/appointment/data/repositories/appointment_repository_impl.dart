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
        endTime: DateTime(2024, 5, 1, 10, 0),
        subject: 'Терентьев М. В.',
        color: Colors.green,
        resourceIds: ['chair1'],
      ),
      Appointment(
        startTime: DateTime(2024, 5, 2, 10, 0),
        endTime: DateTime(2024, 5, 2, 11, 0),
        subject: 'Пискарев А. В.',
        color: Colors.pink,
        resourceIds: ['chair2'],
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
}