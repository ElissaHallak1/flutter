import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focuspocus/providers/pomodoro_provider.dart';
import 'package:focuspocus/widgets/animated_timer.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _selectedWorkTime = 25;
  int _selectedBreakTime = 5;
  
  final List<int> _workTimes = [15, 20, 25, 30, 45, 60];
  final List<int> _breakTimes = [5, 10, 15, 20];

  void _showTimeSettingsDialog(BuildContext context) {
    final provider = Provider.of<PomodoroProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Timer Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Work Session Duration:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _workTimes.map((time) {
                      return ChoiceChip(
                        label: Text('$time min'),
                        selected: _selectedWorkTime == time,
                        onSelected: (selected) {
                          setState(() {
                            _selectedWorkTime = time;
                          });
                        },
                        selectedColor: const Color(0xFFE91E63),
                        labelStyle: TextStyle(
                          color: _selectedWorkTime == time ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  const Text('Break Duration:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _breakTimes.map((time) {
                      return ChoiceChip(
                        label: Text('$time min'),
                        selected: _selectedBreakTime == time,
                        onSelected: (selected) {
                          setState(() {
                            _selectedBreakTime = time;
                          });
                        },
                        selectedColor: const Color(0xFFE91E63),
                        labelStyle: TextStyle(
                          color: _selectedBreakTime == time ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.setWorkDuration(_selectedWorkTime);
                    provider.setBreakDuration(_selectedBreakTime);
                    provider.resetTimer();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroProvider>(
      builder: (context, provider, child) {
        return Container(
          color: const Color(0xFFFCE4EC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.isWorkSession ? 'Work Session' : 'Break Time',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF880E4F),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedTimer(progress: provider.progress),
              const SizedBox(height: 30),
              Text(
                provider.formattedTime,
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '${provider.workDuration ~/ 60} min',
                        style: const TextStyle(
                          color: Color(0xFF880E4F),
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Work',
                        style: TextStyle(
                          color: Color(0xFFAD1457),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    '|',
                    style: TextStyle(
                      color: Color(0xFFE91E63),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      Text(
                        '${provider.breakDuration ~/ 60} min',
                        style: const TextStyle(
                          color: Color(0xFF880E4F),
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Break',
                        style: TextStyle(
                          color: Color(0xFFAD1457),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!provider.isRunning)
                    ElevatedButton(
                      onPressed: provider.startTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Start'),
                    )
                  else
                    ElevatedButton(
                      onPressed: provider.pauseTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF48FB1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Pause'),
                    ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: provider.resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAD1457),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () => _showTimeSettingsDialog(context),
                    icon: const Icon(Icons.settings),
                    color: const Color(0xFFE91E63),
                    iconSize: 30,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _showTimeSettingsDialog(context),
                child: const Text(
                  'Change timer settings',
                  style: TextStyle(
                    color: Color(0xFFE91E63),
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}