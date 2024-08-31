// models/event.dart
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final int? id;
  final String title;
  final String subtitle;
  final DateTime date;

  const Event({
    this.id,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  Event copyWith({int? id, String? title, String? subtitle, DateTime? date}) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date.toIso8601String(),
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      date: DateTime.parse(map['date']),
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, date];
}
