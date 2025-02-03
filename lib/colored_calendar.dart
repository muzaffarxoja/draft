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
    return
      Column(
      children: [
        // Color selection buttons (fixed)
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

        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     children: _colorOptions.asMap().entries.map((entry) {
        //       final index = entry.key;
        //       final color = entry.value;
        //       return Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: InkWell(
        //           onTap: () => setState(() => _currentColorIndex = index),
        //           child: Container(
        //             width: 40,
        //             height: 40,
        //             decoration: BoxDecoration(
        //               color: color,
        //               border: Border.all(
        //                 color: _currentColorIndex == index
        //                     ? Colors.black
        //                     : Colors.transparent,
        //                 width: 2,
        //               ),
        //               shape: BoxShape.rectangle,
        //             ),
        //           ),
        //         ),
        //       );
        //     }).toList(),
        //   ),
        // ),

        TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => _selectedDays.contains(_normalizeDate(day)),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final normalizedDay = _normalizeDate(day); // ✅ Ensure no time issues
              final isToday = isSameDay(normalizedDay, _normalizeDate(DateTime.now()));
              final hasColor = _dayColors.containsKey(normalizedDay);
              final isSelected = _selectedDays.contains(normalizedDay);

              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: isToday
                      ? (isSelected ? _dayColors[normalizedDay] : Colors.yellow)
                      : hasColor
                      ? _dayColors[normalizedDay]
                      : null,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                  border: isToday ? Border.all(color: Colors.greenAccent, width: 3) : null,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isToday ? Colors.green : hasColor ? Colors.black : null,
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
              final today = _normalizeDate(DateTime.now());

              if (_selectedDays.contains(normalizedDate)) {
                _selectedDays.remove(normalizedDate);
                _dayColors.remove(normalizedDate);
              } else {
                _selectedDays.add(normalizedDate);
                _dayColors[normalizedDate] = _colorOptions[_currentColorIndex];
              }

              // Make sure today updates properly
              if (isSameDay(normalizedDate, today)) {
                _dayColors[today] = _colorOptions[_currentColorIndex];
              }
            });

           // print(_dayColors);

          },



          calendarStyle: CalendarStyle(
            todayDecoration: const BoxDecoration(), // Disable default today styling
            outsideDaysVisible: false,
            weekendTextStyle: const TextStyle(color: Colors.red),
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