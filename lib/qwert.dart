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
  final DateTime startTime;
  final DateTime endTime;
  final String myTitle;
  

  PatientAppointment({
    required this.patientName,
    required this.doctorId,
    required this.notes,
    required this.startTime,
    required this.endTime,
    required this.myTitle,
  }) : super(
    date: startTime,
    startTime: startTime,
    endTime: endTime,
    description: notes,
    event: null,
    title: myTitle,
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
      // Add more sample appointments here
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
        myTitle: '',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAppointmentDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateHeader(),
          _buildDoctorHeaders(),
          Expanded(
            child: DayView<PatientAppointment>(
              controller: eventController,
              startDuration: const Duration(hours: 9),
              endHour: 15,
              timeLineWidth: 60,
              timeLineBuilder: _buildTimeLine,
              eventTileBuilder: _buildEventTile,
              onDateLongPress: (date) => _showAddAppointmentDialog(
                context,
                initialDate: date,
              ),
              showVerticalLine: false,
              heightPerMinute: 1.5,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerRight,
      child: Text(
        '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} ${_getDayOfWeek(DateTime.now())}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getDayOfWeek(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  Widget _buildDoctorHeaders() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 60),
          ...doctors.map((doctor) => Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              color: doctor.color,
              child: Column(
                children: [
                  Text(
                    doctor.chair,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    doctor.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTimeLine(DateTime date) {
    return Center(
      child: Text(
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildEventTile(
      DateTime date,
      List<CalendarEventData<PatientAppointment>> events,
      Rect boundary,
      DateTime startDuration,
      DateTime endDuration,
      ) {
    final event = events.first.event!;
    final doctor = doctors.firstWhere((d) => d.id == event.doctorId);

    return GestureDetector(
      onTap: () => _showEditAppointmentDialog(context, event),
      child: Container(
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: doctor.color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.patientName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            if (event.notes.isNotEmpty)
              Text(
                event.notes,
                style: const TextStyle(fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  void _handleEventDragComplete(
      DateTime newStartTime,
      DateTime newEndTime,
      PatientAppointment event,
      ) {
    setState(() {
      eventController.remove(event);
      final newEvent = _createAppointment(
        event.patientName,
        event.doctorId,
        event.notes,
        newStartTime,
        newEndTime,
      );
      eventController.add(newEvent);
    });
  }

  Future<void> _showAddAppointmentDialog(
      BuildContext context, {
        DateTime? initialDate,
      }) async {
    final formKey = GlobalKey<FormState>();
    String patientName = '';
    String selectedDoctorId = doctors.first.id;
    String notes = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Appointment'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => patientName = value ?? '',
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Doctor'),
                value: selectedDoctorId,
                items: doctors.map((doctor) => DropdownMenuItem(
                  value: doctor.id,
                  child: Text(doctor.name),
                )).toList(),
                onChanged: (value) => selectedDoctorId = value ?? doctors.first.id,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                onSaved: (value) => notes = value ?? '',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                final startTime = initialDate ?? DateTime.now();
                final endTime = startTime.add(const Duration(minutes: 30));

                final newEvent = _createAppointment(
                  patientName,
                  selectedDoctorId,
                  notes,
                  startTime,
                  endTime,
                );

                eventController.add(newEvent);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditAppointmentDialog(
      BuildContext context,
      PatientAppointment event,
      ) async {
    final formKey = GlobalKey<FormState>();
    String patientName = event.patientName;
    String selectedDoctorId = event.doctorId;
    String notes = event.notes;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Appointment'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: patientName,
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Required' : null,
                onSaved: (value) => patientName = value ?? '',
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Doctor'),
                value: selectedDoctorId,
                items: doctors.map((doctor) => DropdownMenuItem(
                  value: doctor.id,
                  child: Text(doctor.name),
                )).toList(),
                onChanged: (value) => selectedDoctorId = value ?? doctors.first.id,
              ),
              TextFormField(
                initialValue: notes,
                decoration: const InputDecoration(labelText: 'Notes'),
                onSaved: (value) => notes = value ?? '',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              eventController.remove(event);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();

                eventController.remove(event);
                final newEvent = _createAppointment(
                  patientName,
                  selectedDoctorId,
                  notes,
                  event.startTime,
                  event.endTime,
                );

                eventController.add(newEvent);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}