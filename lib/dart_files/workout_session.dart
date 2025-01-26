// currently this screen only receives the duration
// we can change and get all the other details and the modify this page
// ...............add your logic for further development

import 'package:flutter/material.dart';
import 'dart:async';

class WorkoutSession extends StatefulWidget {
  final String title;
  final String item;
  final String category;
  final int duration;

  const WorkoutSession({
    super.key,
    required this.title,
    required this.item,
    required this.category,
    required this.duration,
  });

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
    if (_isTimerRunning && _timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Workout Plan Details",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Workout: ${widget.item}",
                style: const TextStyle(fontSize: 18)),
            Text("Category: ${widget.category}",
                style: const TextStyle(fontSize: 18)),
            Text("Duration: ${widget.duration} minutes",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Divider(height: 32, thickness: 1.5),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    "Remaining time: $minutes:$seconds",
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _isTimerRunning ? null : _startTimer,
                    icon: const Icon(Icons.timer),
                    label: const Text('Start Timer'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
