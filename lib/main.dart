import 'package:calendar_app/screens/edit_event_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_media_buttons/social_media_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bloc/event_bloc.dart';
import 'bloc/event_event.dart';
import 'bloc/event_state.dart';
import 'data/event_database.dart';
import 'screens/add_event_screen.dart';
import 'widgets/custom_calendar.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<EventBloc>(
      create: (context) => EventBloc(eventDatabase: EventDatabase.instance),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Event Calendar', home: EventPage(), theme: ThemeData.dark());
  }
}

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  DateTime _selectedDate = DateTime.now();

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE, MMMM dd');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${_formatDate(_selectedDate)}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 12.0),
          child: IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bell_fill)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomCalendar(
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AddEventScreen(selectedDate: _selectedDate),
                      ),
                    );
                  },
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  if (state is EventLoaded) {
                    final eventsForSelectedDay = state.events
                        .where((event) => isSameDay(event.date, _selectedDate))
                        .toList();
                    return ListView.builder(
                      itemCount: eventsForSelectedDay.length,
                      itemBuilder: (context, index) {
                        final event = eventsForSelectedDay[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value:
                                          BlocProvider.of<EventBloc>(context),
                                      child: EditEventScreen(event: event),
                                    ),
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              tileColor: Colors.blueAccent,
                              title: Text(event.title),
                              subtitle: Text(event.subtitle),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  BlocProvider.of<EventBloc>(context)
                                      .add(DeleteEvent(event.id!));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is EventError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Column(
              children: [
                const Text('Developed by Azizbek Davronov',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => launchUrl(
                          Uri.https('www.github.com', '/azizbek-davronov')),
                      icon: const Icon(
                        SocialMediaIcons.github_circled,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () => launchUrl(Uri.https(
                          'www.linkedin.com', '/in/aziz-davronov-a410212a3')),
                      icon: const Icon(
                        SocialMediaIcons.linkedin,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () => launchUrl(
                          Uri.https('www.instagram.com', '/aziz.davronov.99')),
                      icon: const Icon(
                        SocialMediaIcons.instagram,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
