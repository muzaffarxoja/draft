import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

/// Define the MedicalEvent model
class MedicalEvent {
  final String patientName;
  final String doctorName;
  final String chairNumber;
  final String? notes;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  MedicalEvent({
    required this.patientName,
    required this.doctorName,
    required this.chairNumber,
    this.notes,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}

class MultiColumnDayView extends StatefulWidget {
  @override
  _MultiColumnDayViewState createState() => _MultiColumnDayViewState();
}

class _MultiColumnDayViewState extends State<MultiColumnDayView> {
  late EventController<MedicalEvent> _eventController;
  DateTime _currentDay = DateTime(2024, 5, 1);

  @override
  void initState() {
    super.initState();
    _eventController = EventController<MedicalEvent>();

    // Sample events
    _eventController.add(CalendarEventData<MedicalEvent>(
      date: _currentDay,
      startTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 0),
      endTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 30),
      title: "Dental Checkup",
      event: MedicalEvent(
        patientName: "John Doe",
        doctorName: "Dr. Smith",
        chairNumber: "3",
        startTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 0),
        endTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 30),
        color: Colors.blue,
      ),
    ));
  }

  void _onDayChanged(DateTime newDay) {
    setState(() {
      _currentDay = newDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${_currentDay.day}.${_currentDay.month}.${_currentDay.year}",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _onDayChanged(_currentDay.subtract(const Duration(days: 1))),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => _onDayChanged(_currentDay.add(const Duration(days: 1))),
          ),
        ],
      ),
      body: Row(
        children: [
          _buildTimeColumn(),
          Expanded(
            child: CalendarControllerProvider<MedicalEvent>(
              controller: _eventController,
              child: DayView<MedicalEvent>(
                controller: CalendarControllerProvider.of<MedicalEvent>(context).controller,
                eventTileBuilder: _customEventTileBuilder,
                heightPerMinute: 1.5,
                startHour: 9,
                endHour: 18,
                showLiveTimeLineInAllDays: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Time Column on the Left
  Widget _buildTimeColumn() {
    return SizedBox(
      width: 60,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10, // Number of time slots
        itemBuilder: (context, index) {
          final hour = 9 + index;
          return SizedBox(
            height: 90,
            child: Center(
              child: Text(
                '$hour:00',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Custom Event Tile Builder
  Widget _customEventTileBuilder(
      DateTime date,
      List<CalendarEventData<MedicalEvent>> events,
      Rect boundary,
      DateTime startDuration,
      DateTime endDuration,
      ) {
    if (events.isEmpty) return Container();
    final event = events[0].event!;

    return Container(
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: event.color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.patientName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (event.notes != null)
              Text(
                event.notes!,
                style: const TextStyle(fontSize: 10),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
