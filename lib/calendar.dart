import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';



// Default Builder in CalendarBuilders

// defaultBuilder: Customizes regular days.
// todayBuilder: Customizes today's appearance.
// selectedBuilder: Customizes selected dates.
// outsideBuilder: Customizes outside month dates.
// markerBuilder: Adds markers (dots, events, etc.).


class MultiSelectCalendar extends StatefulWidget {
  const MultiSelectCalendar({Key? key}) : super(key: key);

  @override
  _MultiSelectCalendarState createState() => _MultiSelectCalendarState();
}

class _MultiSelectCalendarState extends State<MultiSelectCalendar> {
  late DateTime _today; // Normalized today’s date
  bool _isTodaySelected = false;
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
  void initState() {
    super.initState();


    _today = _normalizeDate(DateTime.now()); // Normalize once
  }

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
            return _selectedDays.contains(_normalizeDate(day));
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final normalizedDate = _normalizeDate(day);
              final hasColor = _dayColors.containsKey(normalizedDate);
              final isToday = isSameDay(normalizedDate, _today);

              return Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: hasColor
                      ? _dayColors[normalizedDate] // Use selected color if available
                      : (isToday ? Colors.blue.shade200 : null), // Otherwise, use blue for today

              border: isToday
              ? Border.all(color: hasColor ? Colors.black : Colors.blue, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(8.0),

              //   border: Border.all(
                //     color: isToday
                //         ? (hasColor ? Colors.black : Colors.blue)
                //         : Colors.transparent,
                //     width: isToday ? 2 : 0,
                //   ),
                //   borderRadius: BorderRadius.circular(8.0),
                //
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


              // Toggle selection

              if (isSameDay(normalizedDate, _today)) {
                _isTodaySelected = !_isTodaySelected;
              }
              if (_dayColors.containsKey(normalizedDate)) {
                _dayColors.remove(normalizedDate);
              } else {
                _dayColors[normalizedDate] = _colorOptions[_currentColorIndex];
              }


             // print(_dayColors);

            });
          },

          calendarStyle: CalendarStyle(
            todayTextStyle: const TextStyle(color: Colors.green),
            todayDecoration: BoxDecoration(

              color: _isTodaySelected ? _dayColors[_today] : null, // Change color dynamically
              shape: BoxShape.rectangle, // Change shape dynamically
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.redAccent, width: 2),
            ),

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

  /// Normalizes a date (removes time components)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
