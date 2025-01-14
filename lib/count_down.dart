import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:math';



class CountdownScreen extends StatefulWidget {
  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Timer _timer;
  late DateTime _currentDateTime;
  final DateTime _targetDate = DateTime(2025, 7, 1);
  final DateTime _startDate = DateTime(2025, 1, 1);

  @override
  void initState() {
    super.initState();
    _currentDateTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String days = duration.inDays.toString().padLeft(2, '0');
    String hours = (duration.inHours % 24).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$days:$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    Duration countdown = _targetDate.difference(_currentDateTime);
    Duration totalDuration = _targetDate.difference(_startDate);
    Duration elapsed = _currentDateTime.difference(_startDate);

    double progress = elapsed.inSeconds / totalDuration.inSeconds;
    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;

    String currentMonth = DateFormat('MMM').format(_currentDateTime);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Title
            Text(
              'Countdown Timer',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 50),

            // Circular Progress Indicator with Countdown Details
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 15,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Immigration',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      countdown.isNegative ? "00:00:00:00" : _formatDuration(countdown),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                // Circle for Reached Line
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 270,
                      height: 270,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.withOpacity(0.5)),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(
                        135 * cos(2 * pi * progress - pi / 2),
                        135 * sin(2 * pi * progress - pi / 2),
                      ),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            currentMonth,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),

            // Detailed Countdown (Days, Hours, Minutes, Seconds)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'DAYS',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    Text(
                      countdown.inDays.toString().padLeft(2, '0'),
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  children: [
                    Text(
                      'HOURS',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    Text(
                      (countdown.inHours % 24).toString().padLeft(2, '0'),
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  children: [
                    Text(
                      'MINUTES',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    Text(
                      (countdown.inMinutes % 60).toString().padLeft(2, '0'),
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  children: [
                    Text(
                      'SECONDS',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    Text(
                      (countdown.inSeconds % 60).toString().padLeft(2, '0'),
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
