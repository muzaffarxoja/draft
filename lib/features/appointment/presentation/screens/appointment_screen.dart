import 'package:flutter/material.dart';

import '../../data/repositories/appointment_repository_impl.dart';
import '../widgets/calendar_panel.dart';
import '../widgets/time_table.dart';


class ClinicSchedulerScreen extends StatefulWidget {
  @override
  _ClinicSchedulerScreenState createState() => _ClinicSchedulerScreenState();
}

class _ClinicSchedulerScreenState extends State<ClinicSchedulerScreen> {
  DateTime _selectedDate = DateTime.now();
  final AppointmentService _appointmentService = AppointmentService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkInitialAppointments();
  }

  Future<void> _checkInitialAppointments() async {
    setState(() => _isLoading = true);
    try {
      // Just check if we can fetch data
      await _appointmentService.fetchAppointments();
      await _appointmentService.fetchChairs();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error appropriately
      print('Error checking initial appointments: $e');
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clinic Timetable")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
        children: [
          Container(
            width: 250,
            child: CalendarPanel(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
          ),
          Expanded(
            child: TimetableScreen(selectedDate: _selectedDate),
          ),
        ],
      ),
    );
  }
}