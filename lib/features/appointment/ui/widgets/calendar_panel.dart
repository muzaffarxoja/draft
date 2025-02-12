import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPanel extends StatelessWidget {
  final Function(DateTime) onDateSelected;
  final List<Appointment> appointments;

  CalendarPanel({required this.onDateSelected, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      initialDisplayDate: DateTime(2024, 5, 1),
      view: CalendarView.month,
      firstDayOfWeek: 1,
      dataSource: AppointmentDataSource(appointments),
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
      ),
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          final selectedDate = details.date;
          if (selectedDate != null) {
            onDateSelected(selectedDate);
          }
        }
      },
    );
  }
}

/// **Handles Appointments for the Calendar**
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
