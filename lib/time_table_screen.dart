import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';



class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clinic Timetable")),
      body: SfCalendar(

        view: CalendarView.timelineDay,
        // Use timelineDay for multi-column
        timeSlotViewSettings: TimeSlotViewSettings(
          timelineAppointmentHeight: 100,
          minimumAppointmentDuration: Duration(minutes: 15),
          startHour: 9,
          endHour: 21,
          timeIntervalWidth: 60,
          timeIntervalHeight: 40,
          timeInterval: Duration(minutes: 30),
          timeFormat: 'HH:mm',
        ),

        firstDayOfWeek: 1,
        showCurrentTimeIndicator: true,
        showTodayButton: true,
        showNavigationArrow: true,
        allowDragAndDrop: true,
        allowAppointmentResize: true,
        allowViewNavigation: true,
        resourceViewSettings: ResourceViewSettings(
          size: 40,
          visibleResourceCount: 5, // Number of workstations
        ),
        initialDisplayDate: DateTime(2024, 5, 1),
        dataSource: AppointmentDataSource(_getAppointments(), _getChairs()),
        //appointmentBuilder: _customAppointmentBuilder,
      ),
    );
  }


  Widget _customAppointmentBuilder(BuildContext context, CalendarAppointmentDetails details) {
    final Appointment appointment = details.appointments.first;

    return Container(
      width: details.bounds.width * 0.95,  // ⬆️ Forces wider appointment
      height: 120, // ⬆️ Forces taller appointment
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3, spreadRadius: 1)],
      ),
      child: Text(
        appointment.subject,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, //fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  /// Define the chairs (workstations)
  List<CalendarResource> _getChairs() {
    return [
      CalendarResource(displayName: "Кресло #1", id: "chair1", color: Colors.green),
      CalendarResource(displayName: "Кресло #2", id: "chair2", color: Colors.pink),
      CalendarResource(displayName: "Кресло #3", id: "chair3", color: Colors.purple),
      CalendarResource(displayName: "Кресло #4", id: "chair4", color: Colors.green),
      // CalendarResource(displayName: "Кресло #5", id: "chair1", color: Colors.green),
      // CalendarResource(displayName: "Кресло #6", id: "chair2", color: Colors.pink),
      // CalendarResource(displayName: "Кресло #7", id: "chair3", color: Colors.purple),
      // CalendarResource(displayName: "Кресло #8", id: "chair4", color: Colors.green),

    ];
  }

  /// Define patient appointments
  List<Appointment> _getAppointments() {
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
        endTime: DateTime(2024, 5, 1, 10, 15),
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

// SfCalendar(
// view: CalendarView.timelineDay,
// timeSlotViewSettings: TimeSlotViewSettings(
// timeInterval: Duration(minutes: 15), // Display 15-minute slots
// ),
// allowDragAndDrop: true,
// onDragEnd: (AppointmentDragEndDetails details) {
// final Appointment? appointment = details.appointment as Appointment?;
// if (appointment != null) {
// DateTime newStartTime = _roundToNearestInterval(appointment.startTime, 15);
// DateTime newEndTime = _roundToNearestInterval(appointment.endTime, 15);
//
// // Manually update appointment start and end time
// // You may need to update your data source accordingly
// appointment.startTime = newStartTime;
// appointment.endTime = newEndTime;
// }
// },
// );
//
// DateTime _roundToNearestInterval(DateTime dateTime, int interval) {
// int minutes = dateTime.minute;
// int remainder = minutes % interval;
// if (remainder < interval / 2) {
// return dateTime.subtract(Duration(minutes: remainder)); // Round down
// } else {
// return dateTime.add(Duration(minutes: interval - remainder)); // Round up
// }
// }
//
// SfCalendar(
// view: CalendarView.timelineDay,
// timeSlotViewSettings: TimeSlotViewSettings(
// timeInterval: Duration(minutes: 15), // Display 15-minute slots
// ),
// allowAppointmentResize: true,
// onAppointmentResizeEnd: (AppointmentResizeEndDetails details) {
// final Appointment? appointment = details.appointment as Appointment?;
// if (appointment != null) {
// DateTime newEndTime = _roundToNearestInterval(appointment.endTime, 15);
//
// // Manually update appointment end time to match 15-minute steps
// appointment.endTime = newEndTime;
// }
// },
// );
//
// DateTime _roundToNearestInterval(DateTime dateTime, int interval) {
// int minutes = dateTime.minute;
// int remainder = minutes % interval;
// if (remainder < interval / 2) {
// return dateTime.subtract(Duration(minutes: remainder)); // Round down
// } else {
// return dateTime.add(Duration(minutes: interval - remainder)); // Round up
// }
// }

