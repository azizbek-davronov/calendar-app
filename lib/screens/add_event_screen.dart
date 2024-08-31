// screens/add_event_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../models/event.dart';

class AddEventScreen extends StatelessWidget {
  final DateTime selectedDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  AddEventScreen({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final eventBloc = BlocProvider.of<EventBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: _subtitleController,
              decoration: InputDecoration(labelText: 'Event Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final subtitle = _subtitleController.text;
                print('Title: $title, Subtitle: $subtitle'); // Log the inputs
                if (title.isNotEmpty && subtitle.isNotEmpty) {
                  final event = Event(
                    title: title,
                    subtitle: subtitle,
                    date: selectedDate,
                  );
                  eventBloc.add(AddEvent(event));
                  Navigator.pop(context);
                } else {
                  print('Title or subtitle is empty');
                }
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
