import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Percentage Meter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double percentage1 = 0.0;
  double percentage2 = 0.0;
  Timer? timer1;
  Timer? timer2;
  bool isRunning1 = false;
  bool isRunning2 = false;
  int coins = 0;
  bool isButton1Disabled = false;
  bool isButton2Disabled = false;
  bool isAutoCollectEnabled = true;

  @override
  void dispose() {
    timer1?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  void startProgress1(int time, int coinsEarn) {
    if (!isRunning1) {
      setState(() {
        percentage1 = 0.0;
        isRunning1 = true;
        isButton1Disabled = true; // Disable button1
      });

      final duration = Duration(seconds: time);
      const totalSteps = 100;
      final stepDuration = duration ~/ totalSteps;
      const stepPercentage = 100 / totalSteps;

      int currentStep = 0;

      timer1 = Timer.periodic(stepDuration, (timer) {
        setState(() {
          percentage1 = (currentStep + 1) * stepPercentage;
          currentStep++;

          if (currentStep >= totalSteps) {
            timer.cancel();
            setState(() {
              percentage1 = 0.0;
              isRunning1 = false;
              coins += coinsEarn;
              isButton1Disabled = false; // Enable button1 after progress is over
            });
          }
        });
      });

      Timer(duration, () {
        timer1?.cancel();
        if (isRunning1) {
          setState(() {
            isRunning1 = false;
            coins += coinsEarn;
            isButton1Disabled = false; // Enable button1 after progress is over
          });
        }
      });
    }
  }

  void startProgress2(int time, int coinsEarn) {
    if (!isRunning2) {
      setState(() {
        percentage2 = 0.0;
        isRunning2 = true;
        isButton2Disabled = true; // Disable button2
      });

      final duration = Duration(seconds: time);
      const totalSteps = 100;
      final stepDuration = duration ~/ totalSteps;
      const stepPercentage = 100 / totalSteps;

      int currentStep = 0;

      timer2 = Timer.periodic(stepDuration, (timer) {
        setState(() {
          percentage2 = (currentStep + 1) * stepPercentage;
          currentStep++;

          if (currentStep >= totalSteps) {
            timer.cancel();
            setState(() {
              percentage2 = 0.0;
              isRunning2 = false;
              coins += coinsEarn;
              isButton2Disabled = false; // Enable button2 after progress is over
            });
          }
        });
      });

      Timer(duration, () {
        timer2?.cancel();
        if (isRunning2) {
          setState(() {
            isRunning2 = false;
            coins += coinsEarn;
            isButton2Disabled = false; // Enable button2 after progress is over
          });
        }
      });
    }
  }

  void autoCollect(int time) {
    if (coins >= 10 && isAutoCollectEnabled) {
      setState(() {
        coins -= 10;
        collectCoinsAutomatically(time);
        isAutoCollectEnabled = false; // Disable auto-collect after it has been used once
      });
    }
  }

  void collectCoinsAutomatically(int time) {
    const int progressDuration = 1; // Duration of each progress in seconds

    Timer.run(() {
      startProgress1(progressDuration, 1);
      Timer(const Duration(seconds: progressDuration), () {
        collectCoinsAutomatically(time); // Restart the progress
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text('Coins: $coins'),
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: isButton1Disabled
                          ? null // Disable button1 if isButton1Disabled is true
                          : () {
                              startProgress1(1, 1); // Pass the time duration (5 seconds) to startProgress1
                            },
                      child: const Text('Wheat Fields'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PercentageMeter(
                      percentage: percentage1,
                      screenWidth: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: isButton2Disabled
                          ? null // Disable button2 if isButton2Disabled is true
                          : () {
                              startProgress2(2, 2);
                            },
                      child: const Text('Vineyard Estate'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PercentageMeter(
                      percentage: percentage2,
                      screenWidth: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                autoCollect(5); // Pass the time duration (5 seconds) from the "Wheat Fields" button
              },
              child: Text(isAutoCollectEnabled ? 'AUTO-COLLECT (10 coins)' : 'Wheat Fields Auto-Collect: Used'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PercentageMeter extends StatelessWidget {
  final double percentage;
  final double screenWidth;

  const PercentageMeter({Key? key, required this.percentage, required this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scaleWidth = screenWidth * 0.8; // 80% of the screen width

    return Container(
      height: 20,
      width: scaleWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          Container(
            width: scaleWidth * (percentage / 100),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _getColor(percentage),
            ),
          ),
          LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            value: percentage / 100,
            minHeight: 20,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Color _getColor(double percentage) {
    if (percentage < 35) {
      return Colors.red;
    } else if (percentage < 75) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
