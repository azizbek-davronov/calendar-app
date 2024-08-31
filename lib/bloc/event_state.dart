import 'package:equatable/equatable.dart';
import '../models/event.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Event> events;

  const EventLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object> get props => [message];
}
