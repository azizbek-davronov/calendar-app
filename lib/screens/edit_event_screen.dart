// screens/edit_event_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../models/event.dart';

class EditEventScreen extends StatelessWidget {
  final Event event;
  final TextEditingController _titleController;
  final TextEditingController _subtitleController;

  EditEventScreen({required this.event})
      : _titleController = TextEditingController(text: event.title),
        _subtitleController = TextEditingController(text: event.subtitle);

  @override
  Widget build(BuildContext context) {
    final eventBloc = BlocProvider.of<EventBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
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
                if (title.isNotEmpty && subtitle.isNotEmpty) {
                  final updatedEvent = event.copyWith(
                    title: title,
                    subtitle: subtitle,
                  );
                  eventBloc.add(UpdateEvent(updatedEvent));
                  Navigator.pop(context);
                }
              },
              child: Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }
}
