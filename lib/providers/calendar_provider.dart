import 'package:flutter/material.dart';
import 'package:focuspocus/models/calendar_event.dart';

class CalendarProvider extends ChangeNotifier {
  List<CalendarEvent> _events = [];
  List<CalendarEvent> get events => _events;
  
  int _nextId = 1;

  Future<void> addEvent(CalendarEvent event) async {
    _events.add(event.copyWith(id: _nextId++));
    notifyListeners();
  }

  Future<void> updateEvent(CalendarEvent event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(int id) async {
    _events.removeWhere((event) => event.id == id);
    notifyListeners();
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    return _events.where((event) {
      return event.date.year == day.year &&
          event.date.month == day.month &&
          event.date.day == day.day;
    }).toList();
  }
}