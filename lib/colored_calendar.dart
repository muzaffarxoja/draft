import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ColoredCalendar extends StatefulWidget {
  const ColoredCalendar({Key? key}) : super(key: key);

  @override
  _ColoredCalendarState createState() => _ColoredCalendarState();
}

class _ColoredCalendarState extends State<ColoredCalendar> {
  DateTime _focusedDay = DateTime.now();
  Set<DateTime> _selectedDays = {};
  final Map<DateTime, Color> _dayColors = {};

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
          selectedDayPredicate: (day) {
            return _selectedDays.contains(DateTime(day.year, day.month, day.day));
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final normalizedDate = DateTime(day.year, day.month, day.day);
              final hasColor = _dayColors.containsKey(normalizedDate);
              final isToday = isSameDay(day, DateTime.now());
              final isSelected = _selectedDays.contains(normalizedDate);

              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  // Layer 1: Today's background
                  color: isToday
                      ? Colors.amber.withOpacity(0.2)  // Always show amber for today
                      : hasColor
                      ? _dayColors[normalizedDate]
                      : isSelected
                      ? Colors.blue.withOpacity(0.3)
                      : null,
                  // Layer 2: Selection border
                  border: isSelected
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: hasColor ? Colors.black : null,
                    ),
                  ),
                ),
              );
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

              // Normal selection/deselection for all days including today
              if (_selectedDays.contains(normalizedDate)) {
                _selectedDays.remove(normalizedDate);
              } else {
                _selectedDays.add(normalizedDate);
              }

              // Handle colors
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

        ElevatedButton(
          onPressed: () {
            setState(() {
              _dayColors.clear();
              _selectedDays.clear();
            });
          },
          child: const Text('Clear All Colors'),
        ),
      ],
    );
  }
}