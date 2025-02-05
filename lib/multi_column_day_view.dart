import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'models/medical_event_model.dart';



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
  final List<DoctorSchedule> doctors;

  const MultiColumnDayView({
    Key? key,
    required this.doctors,
  }) : super(key: key);

  @override
  _MultiColumnDayViewState createState() => _MultiColumnDayViewState();
}

class _MultiColumnDayViewState extends State<MultiColumnDayView> {
  late List<EventController<MedicalEvent>> _controllers;
  late ScrollController _scrollController;
  DateTime _currentDay = DateTime(2024, 5, 1);

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
    _scrollController = ScrollController();
    _controllers = List.generate(
      widget.doctors.length,
          (index) => EventController<MedicalEvent>()..addAll(_getSampleEvents(widget.doctors[index])),
    );
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('ru_RU', null);
  }

  List<CalendarEventData<MedicalEvent>> _getSampleEvents(DoctorSchedule doctor) {
    // Sample events for each doctor
    if (doctor.doctorName == "Верстакова А. Г.") {
      return [
        CalendarEventData<MedicalEvent>(
          title: '',
          date: _currentDay,
          startTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 0),
          endTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 30),
          event: MedicalEvent(
            patientName: 'Терентьев М. В.',
            doctorName: doctor.doctorName,
            chairNumber: doctor.chairNumber,
            startTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 0),
            endTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 30),
            color: doctor.columnColor,
          ),
        ),
      ];
    } else if (doctor.doctorName == "Иванова Е. В.") {
      return [
        CalendarEventData<MedicalEvent>(
          title: '',
          date: _currentDay,
          startTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 0),
          endTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 30),
          event: MedicalEvent(
            patientName: 'Шустрова Е. В.',
            doctorName: doctor.doctorName,
            chairNumber: doctor.chairNumber,
            notes: 'верх левая уд 14 17 18',
            startTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 0),
            endTime: DateTime(_currentDay.year, _currentDay.month, _currentDay.day, 9, 30),
            color: doctor.columnColor,
          ),
        ),
      ];
    }
    return [];
  }

  void _onDayChanged(DateTime newDay) {
    setState(() {
      _currentDay = newDay;
      _controllers.forEach((controller) {
        controller.removeAll([]);
        controller.addAll(_getSampleEvents(widget.doctors[_controllers.indexOf(controller)]));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('dd.MM.yyyy EEEE', 'ru_RU').format(_currentDay),
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
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Row(
                children: List.generate(
                  widget.doctors.length,
                      (index) => Expanded(
                    child: CalendarControllerProvider(
                      controller: _controllers[index],
                      child: SizedBox(
                        height: 500,
                        child: DayView<MedicalEvent>(
                          heightPerMinute: 1.5,
                          initialDay: _currentDay,
                          startHour: 9,
                          endHour: 15,
                          timeLineBuilder: _customTimeLineBuilder,
                          eventTileBuilder: _customEventTileBuilder,
                          showVerticalLine: false,
                          showLiveTimeLineInAllDays: false,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: widget.doctors.map((doctor) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            color: doctor.columnColor.withOpacity(0.2),
            child: Column(
              children: [
                Text(
                  'Кресло ${doctor.chairNumber}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  doctor.doctorName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )).toList(),
      ),
    );
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

