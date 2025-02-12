import 'package:draft/features/appointment/ui/widgets/calendar_panel.dart';
import 'package:draft/features/appointment/ui/widgets/time_table.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class ClinicSchedulerScreen extends StatefulWidget {
  @override
  _ClinicSchedulerScreenState createState() => _ClinicSchedulerScreenState();
}

class _ClinicSchedulerScreenState extends State<ClinicSchedulerScreen> {
  DateTime _selectedDate = DateTime.now();
  late List<Appointment> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _getAppointments(); // Load appointments
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clinic Scheduler")),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: CalendarPanel(
              onDateSelected: _updateSelectedDate,
              appointments: _appointments,
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          Expanded(
            flex: 3,
            child: TimetableScreen(
              selectedDate: _selectedDate,
              appointments: _appointments,
            ),
          ),
        ],
      ),
    );
  }

  /// **Define appointment data inside the main screen**
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
