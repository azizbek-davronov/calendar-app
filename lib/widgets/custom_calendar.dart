// widgets/custom_calendar.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  CustomCalendar({required this.onDateSelected});

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final daysInMonth = List.generate(lastDayOfMonth.day, (index) => index + 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday;
    final daysBefore = List.generate(firstWeekdayOfMonth - 1, (index) => 0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.yMMMM().format(_focusedDay),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _focusedDay =
                          DateTime(_focusedDay.year, _focusedDay.month - 1);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _focusedDay =
                          DateTime(_focusedDay.year, _focusedDay.month + 1);
                    });
                  },
                ),
              ],
            )
          ],
        ),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Center(child: Text(day))),
            ...daysBefore.map((_) => SizedBox.shrink()),
            ...daysInMonth.map((day) {
              final date = DateTime(_focusedDay.year, _focusedDay.month, day);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = date;
                  });
                  widget.onDateSelected(date);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedDay == date
                        ? Colors.blueAccent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  margin: EdgeInsets.all(4),
                  child: Center(
                    child: Text(
                      day.toString(),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
