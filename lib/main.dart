import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Is Money',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool isRunning = false;
  int secondsLeft = 60; // 초기 설정: 60초

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '남은 시간: ${secondsLeft.toString()}초',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    startTimer();
                  },
                  child: Text('시작'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    stopTimer();
                  },
                  child: Text('중지'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });
      const oneSec = const Duration(seconds: 1);
      Timer.periodic(oneSec, (Timer timer) {
        setState(() {
          if (secondsLeft < 1) {
            timer.cancel();
            isRunning = false;
          } else {
            secondsLeft = secondsLeft - 1;
          }
        });
      });
    }
  }

  void stopTimer() {
    if (isRunning) {
      setState(() {
        isRunning = false;
        secondsLeft = 60; // 타이머를 중지하면 남은 시간을 다시 60초로 설정
      });
    }
  }
}
