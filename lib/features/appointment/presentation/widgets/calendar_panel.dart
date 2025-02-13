import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../data/datasource/appointment_data_source.dart';
import '../../data/repositories/appointment_repository_impl.dart';


class CalendarPanel extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CalendarPanel({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _CalendarPanelState createState() => _CalendarPanelState();
}

class _CalendarPanelState extends State<CalendarPanel> {
  final AppointmentService _appointmentService = AppointmentService();
  AppointmentDataSource? _appointmentDataSource;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
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
      print('Error loading appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SfCalendar(
      view: CalendarView.month,
      initialSelectedDate: widget.selectedDate,
      onSelectionChanged: (CalendarSelectionDetails details) {
        widget.onDateSelected(details.date!);
      },
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        showAgenda: false,
        monthCellStyle: MonthCellStyle(
          textStyle: TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
          trailingDatesTextStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          leadingDatesTextStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        dayFormat: 'EEE',
      ),
      cellBorderColor: Colors.grey[300],
      dataSource: _appointmentDataSource,
    );
  }
}
