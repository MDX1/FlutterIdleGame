import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double percentage = 0.0;
  Timer? timer;
  bool isRunning = false;
  int coins = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startProgress(int time) {
    if (!isRunning) {
      setState(() {
        percentage = 0.0;
        isRunning = true;
      });

      final duration = Duration(seconds: time);
      const totalSteps = 100;
      final stepDuration = duration ~/ totalSteps;
      const stepPercentage = 100 / totalSteps;

      int currentStep = 0;

      timer = Timer.periodic(stepDuration, (timer) {
        setState(() {
          percentage = (currentStep + 1) * stepPercentage;
          currentStep++;

          if (currentStep >= totalSteps) {
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 100), () {
              setState(() {
                percentage = 0.0;
                isRunning = false;
                coins++;
              });
            });
          }
        });
      });

      Timer(duration, () {
        timer?.cancel();
        if (isRunning) {
          setState(() {
            isRunning = false;
            coins++;
          });
        }
      });
    }
  }

  void autoCollect() {
    if (coins >= 10) {
      setState(() {
        coins -= 10;
        collectCoinsAutomatically();
      });
    }
  }

  void collectCoinsAutomatically() {
    const int progressDuration = 3; // Duration of each progress in seconds
    const int delayDuration = 1; // Delay between each progress in seconds

    Timer(const Duration(seconds: delayDuration), () {
      startProgress(progressDuration);
      Timer(const Duration(seconds: progressDuration), () {
        collectCoinsAutomatically(); // Restart the progress
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Percentage Meter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PercentageMeter(percentage: percentage, screenWidth: MediaQuery.of(context).size.width),
            ElevatedButton(
              onPressed: () {
                startProgress(2);
              },
              child: const Text('Start'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                autoCollect();
              },
              child: const Text('AUTO-COLLECT (10 coins)'),
            ),
            const SizedBox(height: 20),
            Text('Coins: $coins'),
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
