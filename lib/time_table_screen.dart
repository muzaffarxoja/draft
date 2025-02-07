import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';



class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clinic Timetable")),
      body: SfCalendar(
        view: CalendarView.timelineDay, // Use timelineDay for multi-column
        timeSlotViewSettings: TimeSlotViewSettings(
          timeInterval: Duration(minutes: 30),
          timeFormat: 'HH:mm',
        ),
        resourceViewSettings: ResourceViewSettings(
          visibleResourceCount: 3, // Number of workstations
        ),
        dataSource: AppointmentDataSource(_getAppointments(), _getChairs()),
      ),
    );
  }

  /// Define the chairs (workstations)
  List<CalendarResource> _getChairs() {
    return [
      CalendarResource(displayName: "Кресло #1", id: "chair1", color: Colors.green),
      CalendarResource(displayName: "Кресло #2", id: "chair2", color: Colors.pink),
      CalendarResource(displayName: "Кресло #3", id: "chair3", color: Colors.purple),
    ];
  }

  /// Define patient appointments
  List<Appointment> _getAppointments() {
    return [
      Appointment(
        startTime: DateTime(2024, 5, 1, 9, 0),
        endTime: DateTime(2024, 5, 1, 9, 30),
        subject: 'Терентьев М. В.',
        color: Colors.green,
        resourceIds: ['chair1'], // Assigned to Chair #1
      ),
      Appointment(
        startTime: DateTime(2024, 5, 1, 10, 0),
        endTime: DateTime(2024, 5, 1, 10, 30),
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
    ];
  }
}

/// Custom Data Source to handle both Appointments & Resources (Chairs)
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source, List<CalendarResource> resources) {
    appointments = source;
    this.resources = resources; // Correct way to add chairs
  }
}
