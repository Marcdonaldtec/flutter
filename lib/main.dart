import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> words = ['Bonjour', 'Flutter', 'Dart', 'Mobile', 'Application'];
  late String selectedWord;
  late String displayedWord;
  late String hint;
  late int chancesRemaining;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    final _random = Random();
    selectedWord = words[_random.nextInt(words.length)].toUpperCase();
    displayedWord = '*' * selectedWord.length;
    hint = 'C\'est un mot utilisé pour ${selectedWord.toLowerCase()}';
    chancesRemaining = 5;
  }

void resetGame() {
  if (mounted) {
    setState(() {
      startNewGame();
    });
  }
}


  void guessLetter(String letter) {
    if (selectedWord.contains(letter)) {
      List<String> wordList = displayedWord.split('');
      for (int i = 0; i < selectedWord.length; i++) {
        if (selectedWord[i] == letter) {
          wordList[i] = letter;
        }
      }
      displayedWord = wordList.join('');
    } else {
      chancesRemaining--;
    }

    if (displayedWord == selectedWord) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(result: Result.Win, onPlayAgain: resetGame)),
      );
    } else if (chancesRemaining <= 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(result: Result.Lose, onPlayAgain: resetGame)),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guess the Word'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Chances: $chancesRemaining'),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              displayedWord,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Text(
            hint,
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
              itemCount: 26,
              itemBuilder: (context, index) {
                final letter = String.fromCharCode('A'.codeUnitAt(0) + index);
                return GestureDetector(
                  onTap: () => guessLetter(letter),
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum Result { Win, Lose }

class ResultScreen extends StatelessWidget {
  final Result result;
  final VoidCallback onPlayAgain;

  ResultScreen({required this.result, required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result')),
      drawer: DrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result == Result.Win ? 'Congratulations! You Won!' : 'Game Over! You Lost!',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              child: Text('Play Again'),
              onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameScreen()),
              );
            },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('Quit'),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help')),
      drawer: DrawerWidget(),
      body: Center(
        child: Text(
          'Help Screen - Provide game instructions here.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Game Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Game Screen'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GameScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Help'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
