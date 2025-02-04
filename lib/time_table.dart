import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';

class MedicalEvent {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  MedicalEvent({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.color = Colors.blue,
  });
}

class MedicalCalendarView extends StatefulWidget {
  const MedicalCalendarView({Key? key}) : super(key: key);

  @override
  _MedicalCalendarViewState createState() => _MedicalCalendarViewState();
}

class _MedicalCalendarViewState extends State<MedicalCalendarView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Schedule'),
      ),
      body: CalendarControllerProvider(
        controller: EventController<MedicalEvent>()..addAll(_getSampleEvents()),
        child: DayView<MedicalEvent>(
          heightPerMinute: 1.5,
          //startDuration: const Duration(hours: 9),
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
      CalendarEventData(
        title: 'Терентьев М. В.',
        description: 'Appointment with Верстакова А. Г.',
        date: DateTime(2024, 5, 1),
        startTime: DateTime(2024, 5, 1, 9, 0),
        endTime: DateTime(2024, 5, 1, 9, 30),
        color: Colors.green.shade200,
      ),
      CalendarEventData(
        title: 'Шустрова Е. В.',
        description: 'Appointment with Иванова Е. В.',
        date: DateTime(2024, 5, 1),
        startTime: DateTime(2024, 5, 1, 9, 0),
        endTime: DateTime(2024, 5, 1, 9, 30),
        color: Colors.pink.shade200,
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
        color: events[0].color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              events[0].title,
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

