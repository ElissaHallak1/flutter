import 'package:flutter_test/flutter_test.dart';
import 'package:focuspocus/providers/pomodoro_provider.dart';

void main() {
  group('PomodoroProvider', () {
    late PomodoroProvider provider;

    setUp(() {
      provider = PomodoroProvider();
    });

    test('initial state', () {
      expect(provider.isRunning, false);
      expect(provider.isWorkSession, true);
      expect(provider.currentTime, 25 * 60);
      expect(provider.workDuration, 25 * 60);
      expect(provider.breakDuration, 5 * 60);
    });

    test('start timer', () {
      provider.startTimer();
      expect(provider.isRunning, true);
    });

    test('pause timer', () {
      provider.startTimer();
      provider.pauseTimer();
      expect(provider.isRunning, false);
    });

    test('reset timer', () {
      provider.startTimer();
      Future.delayed(const Duration(seconds: 1), () {
        provider.resetTimer();
        expect(provider.isRunning, false);
        expect(provider.currentTime, 25 * 60);
      });
    });

    test('formatted time', () {
      expect(provider.formattedTime, '25:00');
    });

    test('progress calculation', () {
      expect(provider.progress, 0.0);
    });

    test('set work duration', () {
      provider.setWorkDuration(30);
      expect(provider.workDuration, 30 * 60);
    });

    test('set break duration', () {
      provider.setBreakDuration(10);
      expect(provider.breakDuration, 10 * 60);
    });

    test('session switching', () {
      provider.setWorkDuration(0); 
      provider.startTimer();
      expect(provider.isWorkSession, true); 
    });
  });
}