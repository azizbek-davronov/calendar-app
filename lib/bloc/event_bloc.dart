// bloc/event_bloc.dart
import 'package:bloc/bloc.dart';
import '../data/event_database.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventDatabase eventDatabase;

  EventBloc({required this.eventDatabase}) : super(EventLoading()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<UpdateEvent>(_onUpdateEvent);
  }

  void _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    try {
      final events = await eventDatabase.readAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError('Failed to fetch events: $e'));
    }
  }

  void _onAddEvent(AddEvent event, Emitter<EventState> emit) async {
    try {
      await eventDatabase.create(event.event);
      final events = await eventDatabase.readAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError('Failed to add event: $e'));
    }
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<EventState> emit) async {
    try {
      await eventDatabase.delete(event.id);
      final events = await eventDatabase.readAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError('Failed to delete event: $e'));
    }
  }

  void _onUpdateEvent(UpdateEvent event, Emitter<EventState> emit) async {
    try {
      await eventDatabase.update(event.event);
      final events = await eventDatabase.readAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError('Failed to update event: $e'));
    }
  }
}
