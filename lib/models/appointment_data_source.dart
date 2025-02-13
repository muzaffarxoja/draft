import 'package:syncfusion_flutter_calendar/calendar.dart';


/// Custom Data Source to handle both Appointments & Resources (Chairs)
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> appointments, List<CalendarResource> resources) {
    this.appointments = appointments;
    this.resources = resources;
  }
}
