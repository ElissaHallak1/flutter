import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroProvider extends ChangeNotifier {
  Timer? _timer;
  int _workDuration = 25 * 60;  
  int _breakDuration = 5 * 60;   
  int _currentTime = 25 * 60;
  bool _isRunning = false;
  bool _isWorkSession = true;

  int get currentTime => _currentTime;
  bool get isRunning => _isRunning;
  bool get isWorkSession => _isWorkSession;
  int get workDuration => _workDuration;
  int get breakDuration => _breakDuration;

  PomodoroProvider() {
    _currentTime = _workDuration;
  }

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime > 0) {
        _currentTime--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        _switchSession();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _currentTime = _isWorkSession ? _workDuration : _breakDuration;
    notifyListeners();
  }

  void _switchSession() {
    _isWorkSession = !_isWorkSession;
    _currentTime = _isWorkSession ? _workDuration : _breakDuration;
  }

  void setWorkDuration(int minutes) {
    _workDuration = minutes * 60;
    if (_isWorkSession && !_isRunning) {
      _currentTime = _workDuration;
    }
    notifyListeners();
  }

  void setBreakDuration(int minutes) {
    _breakDuration = minutes * 60;
    if (!_isWorkSession && !_isRunning) {
      _currentTime = _breakDuration;
    }
    notifyListeners();
  }

  String get formattedTime {
    final minutes = (_currentTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_currentTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get progress {
    final total = _isWorkSession ? _workDuration : _breakDuration;
    return 1 - (_currentTime / total);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}