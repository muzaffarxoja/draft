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
        // Color selection buttons (fixed)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _colorOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final color = entry.value;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => setState(() => _currentColorIndex = index),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: _currentColorIndex == index
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                      shape: BoxShape.rectangle,
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
          selectedDayPredicate: (day) => _selectedDays.contains(_normalizeDate(day)),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final normalizedDate = _normalizeDate(day);
              final hasColor = _dayColors.containsKey(normalizedDate);
              final isToday = isSameDay(day, DateTime.now());

              return Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: hasColor ? _dayColors[normalizedDate] : null,
                  border: isToday
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(0), // Rectangular shape
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: hasColor ? Colors.black : null,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
              final normalizedDate = _normalizeDate(selectedDay);

              if (_selectedDays.contains(normalizedDate)) {
                _selectedDays.remove(normalizedDate);
                _dayColors.remove(normalizedDate);
              } else {
                _selectedDays.add(normalizedDate);
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
          onPressed: () => setState(() {
            _dayColors.clear();
            _selectedDays.clear();
          }),
          child: const Text('Clear All Colors'),
        ),
      ],
    );
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}