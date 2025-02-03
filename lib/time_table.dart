// main.dart
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Appointments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalendarControllerProvider(
        controller: EventController<PatientAppointment>(),
        child: const AppointmentScheduler(),
      ),
    );
  }
}

// models.dart
class Doctor {
  final String id;
  final String name;
  final String chair;
  final Color color;

  Doctor({
    required this.id,
    required this.name,
    required this.chair,
    required this.color,
  });
}

class PatientAppointment extends CalendarEventData<PatientAppointment> {
  final String patientName;
  final String doctorId;
  final String notes;

  PatientAppointment({
    required this.patientName,
    required this.doctorId,
    required this.notes,
    required DateTime startTime,
    required DateTime endTime,
  }) : super(
    date: startTime,
    startTime: startTime,
    endTime: endTime,
    title: patientName,
    description: notes,
    event: null,
  );
}

// appointment_scheduler.dart
class AppointmentScheduler extends StatefulWidget {
  const AppointmentScheduler({Key? key}) : super(key: key);

  @override
  State<AppointmentScheduler> createState() => _AppointmentSchedulerState();
}

class _AppointmentSchedulerState extends State<AppointmentScheduler> {
  late EventController<PatientAppointment> eventController;

  final List<Doctor> doctors = [
    Doctor(
      id: '1',
      name: 'Verstakova A. G.',
      chair: 'Chair #1',
      color: const Color(0xFFD1F2E4),
    ),
    Doctor(
      id: '2',
      name: 'Ivanova E. V.',
      chair: 'Chair #2',
      color: const Color(0xFFF8D7E6),
    ),
    Doctor(
      id: '3',
      name: 'Brantova G. K.',
      chair: 'Chair #3',
      color: const Color(0xFFE6D7F8),
    ),
  ];

  @override
  void initState() {
    super.initState();
    eventController = EventController<PatientAppointment>();
    _addInitialAppointments();
  }

  void _addInitialAppointments() {
    final today = DateTime.now();
    final appointments = [
      _createAppointment(
        'Terentiev M. B.',
        '1',
        '',
        DateTime(today.year, today.month, today.day, 9, 0),
        DateTime(today.year, today.month, today.day, 9, 30),
      ),
      _createAppointment(
        'Shustrova E. V.',
        '2',
        'upper left ud 14 17 18',
        DateTime(today.year, today.month, today.day, 9, 0),
        DateTime(today.year, today.month, today.day, 9, 30),
      ),
    ];

    eventController.addAll(appointments);
  }

  CalendarEventData<PatientAppointment> _createAppointment(
      String patientName,
      String doctorId,
      String notes,
      DateTime startTime,
      DateTime endTime,
      ) {
    return CalendarEventData<PatientAppointment>(
      date: startTime,
      startTime: startTime,
      endTime: endTime,
      title: patientName,
      description: notes,
      event: PatientAppointment(
        patientName: patientName,
        doctorId: doctorId,
        notes: notes,
        startTime: startTime,
        endTime: endTime,
      ),
    );
  }

  @override
  void dispose() {
    eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Appointments'),
      ),
      body: Center(
        child: Text('Appointment Scheduler UI Goes Here'),
      ),
    );
  }
}
