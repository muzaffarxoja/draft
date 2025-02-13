// appointment_data_source.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource({
    required List<Appointment> appointments,
    required List<CalendarResource> resources,
  }) {
    this.appointments = appointments;
    this.resources = resources;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<Appointment> getAppointmentsForDate(DateTime date) {
    return appointments!
        .whereType<Appointment>()
        .where((appointment) => isSameDay(appointment.startTime, date))
        .toList();
  }
}