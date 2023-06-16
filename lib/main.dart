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
  double percentage3 = 0.0;
  double percentage4 = 0.0;
  Timer? timer1;
  Timer? timer2;
  Timer? timer3;
  Timer? timer4;
  bool isRunning1 = false;
  bool isRunning2 = false;
  bool isRunning3 = false;
  bool isRunning4 = false;
  int coins = 0;
  bool isButton1Disabled = false;
  bool isButton2Disabled = false;
  bool isButton3Disabled = false;
  bool isButton4Disabled = false;

  @override
  void dispose() {
    timer1?.cancel();
    timer2?.cancel();
    timer3?.cancel();
    timer4?.cancel();
    super.dispose();
  }

  void startProgress(int time, int coinsEarn, int buttonIndex) {
    if ((buttonIndex == 1 && !isRunning1) ||
        (buttonIndex == 2 && !isRunning2) ||
        (buttonIndex == 3 && !isRunning3) ||
        (buttonIndex == 4 && !isRunning4)) {
      setState(() {
        if (buttonIndex == 1) {
          percentage1 = 0.0;
          isRunning1 = true;
          isButton1Disabled = true; // Disable button1
        } else if (buttonIndex == 2) {
          percentage2 = 0.0;
          isRunning2 = true;
          isButton2Disabled = true; // Disable button2
        } else if (buttonIndex == 3) {
          percentage3 = 0.0;
          isRunning3 = true;
          isButton3Disabled = true; // Disable button3
        } else if (buttonIndex == 4) {
          percentage4 = 0.0;
          isRunning4 = true;
          isButton4Disabled = true; // Disable button4
        }
      });

      final duration = Duration(seconds: time);
      const totalSteps = 100;
      final stepDuration = duration ~/ totalSteps;
      const stepPercentage = 100 / totalSteps;

      int currentStep = 0;
      Timer? timer;

      timer = Timer.periodic(stepDuration, (timer) {
        setState(() {
          if (buttonIndex == 1) {
            percentage1 = (currentStep + 1) * stepPercentage;
          } else if (buttonIndex == 2) {
            percentage2 = (currentStep + 1) * stepPercentage;
          } else if (buttonIndex == 3) {
            percentage3 = (currentStep + 1) * stepPercentage;
          } else if (buttonIndex == 4) {
            percentage4 = (currentStep + 1) * stepPercentage;
          }
          currentStep++;

          if (currentStep >= totalSteps) {
            timer.cancel();
            setState(() {
              if (buttonIndex == 1) {
                percentage1 = 0.0;
                isRunning1 = false;
                coins += coinsEarn;
                isButton1Disabled = false; // Enable button1 after progress is over
              } else if (buttonIndex == 2) {
                percentage2 = 0.0;
                isRunning2 = false;
                coins += coinsEarn;
                isButton2Disabled = false; // Enable button2 after progress is over
              } else if (buttonIndex == 3) {
                percentage3 = 0.0;
                isRunning3 = false;
                coins += coinsEarn;
                isButton3Disabled = false; // Enable button3 after progress is over
              } else if (buttonIndex == 4) {
                percentage4 = 0.0;
                isRunning4 = false;
                coins += coinsEarn;
                isButton4Disabled = false; // Enable button4 after progress is over
              }
            });
          }
        });
      });

      Timer(duration, () {
        timer?.cancel();
        if (buttonIndex == 1 && isRunning1) {
          setState(() {
            isRunning1 = false;
            coins += coinsEarn;
            isButton1Disabled = false; // Enable button1 after progress is over
          });
        } else if (buttonIndex == 2 && isRunning2) {
          setState(() {
            isRunning2 = false;
            coins += coinsEarn;
            isButton2Disabled = false; // Enable button2 after progress is over
          });
        } else if (buttonIndex == 3 && isRunning3) {
          setState(() {
            isRunning3 = false;
            coins += coinsEarn;
            isButton3Disabled = false; // Enable button3 after progress is over
          });
        } else if (buttonIndex == 4 && isRunning4) {
          setState(() {
            isRunning4 = false;
            coins += coinsEarn;
            isButton4Disabled = false; // Enable button4 after progress is over
          });
        }
      });
    }
  }

  void autoCollect(int time) {
    if (coins >= 10) {
      setState(() {
        coins -= 10;
        collectCoinsAutomatically(time);
      });
    }
  }

  void collectCoinsAutomatically(int time) {
    const int progressDuration = 1; // Duration of each progress in seconds

    Timer.run(() {
      startProgress(progressDuration, 1, 1);
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
                              startProgress(1, 1, 1); // Pass the time duration (1 second) to startProgress for button1
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
                              startProgress(2, 2, 2); // Pass the time duration (2 seconds) to startProgress for button2
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
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: isButton3Disabled
                          ? null // Disable button3 if isButton3Disabled is true
                          : () {
                              startProgress(4, 6, 3); // Pass the time duration (4 seconds) to startProgress for button3
                            },
                      child: const Text('Sunflower Plantation'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PercentageMeter(
                      percentage: percentage3,
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
                      onPressed: isButton4Disabled
                          ? null // Disable button4 if isButton4Disabled is true
                          : () {
                              startProgress(8, 15, 4); // Pass the time duration (8 seconds) to startProgress for button4
                            },
                      child: const Text('Apple Orchard Estate'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PercentageMeter(
                      percentage: percentage4,
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
              child: const Text('AUTO-COLLECT (10 coins)'),
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
