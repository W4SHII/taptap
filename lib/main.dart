import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(TapGameApp());
}

class TapGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GameScreen());
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int timeLeft = 30;
  bool gameStarted = false;
  Timer? timer;

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      gameStarted = true;
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          gameStarted = false;
          t.cancel();
          showGameOverDialog();
        }
      });
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("Your score is $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void increaseScore() {
    if (gameStarted) {
      setState(() {
        score++;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Time: $timeLeft",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Score: $score",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: increaseScore,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(40),
                shape: CircleBorder(),
              ),
              child: Text("TAP!", style: TextStyle(fontSize: 24)),
            ),
            SizedBox(height: 40),
            if (!gameStarted)
              ElevatedButton(onPressed: startGame, child: Text("Start Game")),
          ],
        ),
      ),
    );
  }
}
