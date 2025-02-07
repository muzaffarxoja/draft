import 'package:flutter/material.dart';

class DentalScheduler extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Date header
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Text(
              '01.05.2024 Среда',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Schedule grid
          Expanded(
            child: Row(
              children: [
                // Timeline
                _buildTimeline(),
                // Chair columns
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildChairColumn(
                        'Кресло #1\nВерстакова А. Г.',
                        Colors.green.shade100,
                        chair1Appointments,
                      ),
                      _buildChairColumn(
                        'Кресло #2\nИванова Е. В.',
                        Colors.pink.shade100,
                        chair2Appointments,
                      ),
                      _buildChairColumn(
                        'Кресло #3\nБрантова Г. К.',
                        Colors.purple.shade100,
                        chair3Appointments,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return SizedBox(
      width: 50,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: 13, // 9:00 to 15:00
        itemBuilder: (context, index) {
          final hour = 9 + index;
          return Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(
              '$hour:00',
              style: TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChairColumn(String title, Color color, List<Appointment> appointments) {
    return Expanded(
      child: Column(
        children: [
          // Chair header
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          // Appointments area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey.shade300),
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Stack(
                children: [
                  // Time slots background
                  ListView.builder(
                    controller: _scrollController,
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      );
                    },
                  ),
                  // Appointments
                  ...appointments.map((apt) => Positioned(
                    top: _calculateTopPosition(apt.startTime),
                    left: 0,
                    right: 0,
                    height: _calculateHeight(apt.startTime, apt.endTime),
                    child: Container(
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apt.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (apt.note != null)
                            Text(
                              apt.note!,
                              style: TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTopPosition(DateTime time) {
    final startHour = 9.0;
    final timeInHours = time.hour + (time.minute / 60.0);
    return (timeInHours - startHour) * 60;
  }

  double _calculateHeight(DateTime start, DateTime end) {
    final durationInHours = end.difference(start).inMinutes / 60.0;
    return durationInHours * 60;
  }
}

class Appointment {
  final DateTime startTime;
  final DateTime endTime;
  final String name;
  final String? note;

  const Appointment({
    required this.startTime,
    required this.endTime,
    required this.name,
    this.note,
  });
}

// Sample appointment data
final chair1Appointments = [
  Appointment(
    startTime: DateTime(2024, 5, 1, 9, 0),
    endTime: DateTime(2024, 5, 1, 9, 30),
    name: 'Терентьев М. В.',
  ),
  Appointment(
    startTime: DateTime(2024, 5, 1, 10, 0),
    endTime: DateTime(2024, 5, 1, 10, 30),
    name: 'Степанов С.',
    note: 'конс-я',
  ),
];

final chair2Appointments = [
  Appointment(
    startTime: DateTime(2024, 5, 1, 9, 0),
    endTime: DateTime(2024, 5, 1, 10, 0),
    name: 'Шустрова Е. В.',
    note: 'верх левая уд 14 17 18',
  ),
  Appointment(
    startTime: DateTime(2024, 5, 1, 11, 0),
    endTime: DateTime(2024, 5, 1, 12, 0),
    name: 'Кафтанова Т. В.',
  ),
];

final chair3Appointments = [
  Appointment(
    startTime: DateTime(2024, 5, 1, 9, 30),
    endTime: DateTime(2024, 5, 1, 10, 0),
    name: 'Кузьмина Е. Н.',
    note: 'оттиск под съемный',
  ),
];