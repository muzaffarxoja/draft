import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';

class MedicalEvent {
  final String patientName; // More descriptive name
  final String doctorName;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  MedicalEvent({
    required this.patientName,
    required this.doctorName,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.color = Colors.blue,
  });

// ... (equality overrides as before)
}


class MedicalCalendarView extends StatefulWidget {
  const MedicalCalendarView({Key? key}) : super(key: key);

  @override
  _MedicalCalendarViewState createState() => _MedicalCalendarViewState();
}

class _MedicalCalendarViewState extends State<MedicalCalendarView> {

  late EventController<MedicalEvent> _controller;


  @override
  void initState() {

    super.initState();
    _controller = EventController<MedicalEvent>(); // Initialize in initState
    _controller.addAll(_getSampleEvents()); // Add events

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Schedule'),
      ),
      body: CalendarControllerProvider(
        controller: _controller,//EventController<MedicalEvent>()..addAll(_getSampleEvents()),
        child: DayView<MedicalEvent>(
          heightPerMinute: 1.5,
          initialDay: DateTime(2024, 5, 1),
          startHour: 9,  // Start the schedule at 9:00 AM
          endHour: 18,   // End the schedule at 6:00 PM
          timeLineBuilder: _customTimeLineBuilder,
          eventTileBuilder: _customEventTileBuilder,
        ),
      ),
    );
  }

  List<CalendarEventData<MedicalEvent>> _getSampleEvents() {
    return [
      CalendarEventData<MedicalEvent>( // Specify MedicalEvent as the generic type
        date: DateTime(2024, 5, 1),
        startTime: DateTime(2024, 5, 1, 9, 0),
        endTime: DateTime(2024, 5, 1, 9, 30),
        title: 'sdfsf',
        event: MedicalEvent( // Create the MedicalEvent instance
          patientName: 'Терентьев М. В.',
          doctorName: 'Верстакова А. Г.',
          description: 'Appointment with Верстакова А. Г.',
          startTime: DateTime(2024, 5, 1, 9, 0),
          endTime: DateTime(2024, 5, 1, 9, 30),
          color: Colors.green.shade200,
        ),
      ),
      CalendarEventData<MedicalEvent>(
        date: DateTime(2024, 5, 1),
        startTime: DateTime(2024, 5, 1, 9, 0),
        endTime: DateTime(2024, 5, 1, 9, 30),
        title: 'dsfsdffsdf',
        event: MedicalEvent(
          patientName: 'Шустрова Е. В.',
          doctorName: 'Иванова Е. В.',
          description: 'Appointment with Иванова Е. В.',
          startTime: DateTime(2024, 5, 1, 9, 0),
          endTime: DateTime(2024, 5, 1, 9, 30),
          color: Colors.pink.shade200,
        ),
      ),
    ];
  }

  Widget _customTimeLineBuilder(DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        DateFormat('HH:mm').format(date),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _customEventTileBuilder(
      DateTime date,
      List<CalendarEventData<MedicalEvent>> events,
      Rect boundary,
      DateTime startDuration,
      DateTime endDuration,
      ) {
    if (events.isEmpty) return Container();

    return Container(
      decoration: BoxDecoration(
        color: events[0].event?.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              events[0].event?.patientName ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (events[0].description?.isNotEmpty ?? false)
              Text(
                events[0].description ?? '',
                style: const TextStyle(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

