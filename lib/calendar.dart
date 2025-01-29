import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MultiSelectCalendar extends StatefulWidget {
  const MultiSelectCalendar({Key? key}) : super(key: key);

  @override
  _MultiSelectCalendarState createState() => _MultiSelectCalendarState();
}

class _MultiSelectCalendarState extends State<MultiSelectCalendar> {
  DateTime _today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Set<DateTime> _selectedDays = {};

  // Map to store colors for specific dates
  final Map<DateTime, Color> _dayColors = {};

  // Example color options
  final List<Color> _colorOptions = [
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.purple.shade200,
    Colors.orange.shade200,
  ];
  int _currentColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Color selection buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _colorOptions.map((color) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentColorIndex = _colorOptions.indexOf(color);
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: _colorOptions[_currentColorIndex] == color
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _focusedDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          weekendDays: const [DateTime.sunday],
          selectedDayPredicate: (day) {
            return _selectedDays
                .contains(DateTime(day.year, day.month, day.day));
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              // Normalize the date for comparison
              final normalizedDate = DateTime(day.year, day.month, day.day);
              final hasColor = _dayColors.containsKey(normalizedDate);
              final isToday = isSameDay(day, DateTime.now());

              if (hasColor || isToday) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: hasColor ? _dayColors[normalizedDate] : null,
                    border: isToday
                        ? Border.all(color: Colors.blue, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: hasColor ? Colors.black : null,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
              final normalizedDate = DateTime(
                selectedDay.year,
                selectedDay.month,
                selectedDay.day,
              );

              // Toggle color on tap
              if (_dayColors.containsKey(normalizedDate)) {
                _dayColors.remove(normalizedDate);
              } else {
                _dayColors[normalizedDate] = _colorOptions[_currentColorIndex];
              }
            });
          },
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            weekendTextStyle: TextStyle(color: Colors.red),
          ),
        ),

        // Clear button
        ElevatedButton(
          onPressed: () {
            setState(() {
              _dayColors.clear();
            });
          },
          child: const Text('Clear All Colors'),
        ),
      ],
    );
  }
}
