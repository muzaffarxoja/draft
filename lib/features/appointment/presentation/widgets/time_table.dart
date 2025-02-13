// timetable_screen.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../data/datasource/appointment_data_source.dart';
import '../../data/repositories/appointment_repository_impl.dart';

class TimetableScreen extends StatefulWidget {
  final DateTime selectedDate;

  const TimetableScreen({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  AppointmentDataSource? _appointmentDataSource;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  @override
  void didUpdateWidget(TimetableScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadAppointments();
    }
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);
    try {
      final appointments = await _appointmentService.fetchAppointments();
      final chairs = await _appointmentService.fetchChairs();

      setState(() {
        _appointmentDataSource = AppointmentDataSource(
          appointments: appointments,
          resources: chairs,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error appropriately
      print('Error loading appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SfCalendar(
      view: CalendarView.timelineDay,
      timeSlotViewSettings: TimeSlotViewSettings(
        timelineAppointmentHeight: 50,
        minimumAppointmentDuration: Duration(minutes: 15),
        startHour: 9,
        endHour: 21,
        timeIntervalWidth: 60,
        timeIntervalHeight: 40,
        timeInterval: Duration(minutes: 30),
        timeFormat: 'HH:mm',
      ),
      headerDateFormat: 'dd.MM.yyyy EEEE',
      firstDayOfWeek: 1,
      showCurrentTimeIndicator: true,
      showNavigationArrow: true,
      allowDragAndDrop: true,
      allowAppointmentResize: true,
      allowViewNavigation: true,
      resourceViewSettings: ResourceViewSettings(
        size: 60,
        showAvatar: false,
        visibleResourceCount: 4,
      ),
      initialDisplayDate: widget.selectedDate,
      dataSource: _appointmentDataSource,
      appointmentBuilder: _customAppointmentBuilder,
    );
  }

  Widget _customAppointmentBuilder(BuildContext context, CalendarAppointmentDetails details) {
    final Appointment appointment = details.appointments.first;

    return Container(
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.subject,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}