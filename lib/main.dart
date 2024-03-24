import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

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
  @override
  void initState() {
    super.initState();
  }

  bool isRunning = false;
  int timeLeft = 0;
  int settingTime = 0;
  TextEditingController minuteController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  late Timer timer;

  String convertSecondsToHMS(int seconds) {
    int hours = seconds ~/ 3600;
    int remainingSeconds = seconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    int remainingSecondsFinal = remainingSeconds % 60;

    String result = '';

    result += hours > 9 ? '$hours : ' : '${hours.toString().padLeft(2,'0')} : ';
    result += minutes > 9 ? '$minutes : ' : '${minutes.toString().padLeft(2,'0')} : ';
    result += remainingSecondsFinal > 9 ? '$remainingSecondsFinal' : remainingSecondsFinal.toString().padLeft(2,'0');

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💰 Time Is Money 💰'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(convertSecondsToHMS(timeLeft)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    isRunning ? pauseTimer() : startTimer();
                  },
                  child: isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    refreshTimer();
                  },
                  child: Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        shape: CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('타이머 설정하기'),
                content: Container(
                  width: 200,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: hourController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          decoration: InputDecoration(hintText: "00"),
                          buildCounter: (context,
                                  {required int currentLength,
                                  required int? maxLength,
                                  required bool isFocused}) =>
                              null,
                        ),
                      ),
                      Text(":"),
                      Expanded(
                        child: TextField(
                          controller: minuteController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          decoration: InputDecoration(hintText: "00"),
                          buildCounter: (context,
                                  {required int currentLength,
                                  required int? maxLength,
                                  required bool isFocused}) =>
                              null,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      settingTime =
                          (int.tryParse(hourController.text) ?? 0) * 3600 +
                              (int.tryParse(minuteController.text) ?? 0) * 60;
                      timeLeft =
                          (int.tryParse(hourController.text) ?? 0) * 3600 +
                              (int.tryParse(minuteController.text) ?? 0) * 60;
                      setState(() {});
                      print("dd");
                      Navigator.of(context).pop();
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void startTimer() {
    if (settingTime == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("시간 설정 먼저 해주세요"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("확인"))
              ],
            );
          });
      return;
    }
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });
      const oneSec = const Duration(seconds: 1);
      timer = Timer.periodic(oneSec, (Timer timer) {
        setState(() {
          if (timeLeft < 1) {
            timer.cancel();
            isRunning = false;
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("타이머 종료"),
                    content: Text("축하합니다! 정한 시간만큼 열심히 달렸네요!"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            timeLeft = settingTime;
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: Text("확인"))
                    ],
                  );
                });
          } else {
            timeLeft = timeLeft - 1;
          }
        });
      });
    }
  }

  void refreshTimer() {
    if(timer != null && timer.isActive){
      timer.cancel();
    }
      setState(() {
        isRunning = false;
        timeLeft = settingTime;
      });
  }

  pauseTimer() {
    if (timer != null && timer.isActive) {
      timer.cancel();
      setState(() {
        isRunning = false;
      });
    }
  }
}
