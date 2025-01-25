import 'package:flutter/material.dart';
import 'dart:async';

// currently this screen only receives the duration
// we can change and get all the other details and the modify this page
// ...............add your logic for further development

class WorkoutSession extends StatefulWidget {
  final int duration;
  const WorkoutSession({super.key, required this.duration});

  @override
  State<WorkoutSession> createState() => _WorkoutSessionState();
}

class _WorkoutSessionState extends State<WorkoutSession> {
  late int _remainingTime;
  late Timer _timer;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration * 60;
  }

  void _startTimer() {
    if (_isTimerRunning) return;

    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          _isTimerRunning = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Session"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Remaining time: ${_remainingTime} seconds",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isTimerRunning ? null : _startTimer,
              child: const Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
