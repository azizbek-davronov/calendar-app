// bloc/event_event.dart
import 'package:equatable/equatable.dart';
import '../models/event.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends EventEvent {}

class AddEvent extends EventEvent {
  final Event event;

  const AddEvent(this.event);

  @override
  List<Object> get props => [event];
}

class DeleteEvent extends EventEvent {
  final int id;

  const DeleteEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateEvent extends EventEvent {
  final Event event;

  const UpdateEvent(this.event);

  @override
  List<Object> get props => [event];
}
