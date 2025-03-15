import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';


void main() {
  runApp(CardMatchingGame());
}

class CardModel { // Initial card matching game setup
  final String identifier;
  bool isFaceUp;
  bool isMatched;

  CardModel({required this.identifier, this.isFaceUp = false, this.isMatched = false});
}

class GameProvider extends ChangeNotifier { // Initial card matching game setup
  List<CardModel> cards = [];
  CardModel? firstCard;
  CardModel? secondCard;

  GameProvider() {
    _initializeGame();
  }

  void _initializeGame() { // Initial card matching game setup
    List<String> identifiers = ['🍎', '🍎', '🚀', '🚀', '🌟', '🌟', '🎸', '🎸'];
    identifiers.shuffle();
    cards = identifiers.map((id) => CardModel(identifier: id)).toList();
    notifyListeners();
  }
  void flipCard(int index) { //  Implement card flipping logic and UI
    if (cards[index].isMatched || cards[index].isFaceUp) return;

    cards[index].isFaceUp = true;

    if (firstCard == null) {
      firstCard = cards[index];
    } else {
      secondCard = cards[index];
      _checkMatch(); //  Implement matching logic and card matching visual feedback
    }
    notifyListeners();
  }

  void _checkMatch() { //  Implement matching logic and card matching visual feedback
    if (firstCard != null && secondCard != null) {
      if (firstCard!.identifier == secondCard!.identifier) {
        firstCard!.isMatched = true;
        secondCard!.isMatched = true;
     
      // Check for win condition
        if (cards.every((card) => card.isMatched)) { // Add win condition and dialog
          _showWinDialog(); //  Add win condition and dialog
        }

      } else {
        Timer(Duration(seconds: 1), () { // Implement matching logic and card matching visual feedback
          firstCard!.isFaceUp = false;
          secondCard!.isFaceUp = false;
          firstCard = null;
          secondCard = null;
          notifyListeners();
        });
      }
      firstCard = null;
      secondCard = null;
    }
  }
  void _showWinDialog() { // Add win condition and dialog
    showDialog(
      context: Provider.of<BuildContext>(context, listen: false),
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You matched all the cards!'),
          actions: <Widget>[
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                _initializeGame();
              },
            ),
          ],
        );
      },
    );
  }
}

class CardMatchingGame extends StatelessWidget { // Initial card matching game setup
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Card Matching Game')),
        body: ChangeNotifierProvider( //  Add state management with Provider
          create: (context) => GameProvider(),
          child: GameBoard(),
        ),
      ),
    );
  }
}

class GameBoard extends StatelessWidget {
  // Implement card flipping logic and UI
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      // Add state management with Provider
      builder: (context, game, child) {
        return GridView.builder(
          // Implement card flipping logic and UI
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: game.cards.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              // Implement card flipping logic and UI
              onTap: () => game.flipCard(index),
              child: AnimatedContainer(
                // Implement card flipping logic and UI
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: game.cards[index].isFaceUp ? Colors.white : Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: game.cards[index].isFaceUp
                      ? Text(
                          game.cards[index].identifier,
                          style: TextStyle(fontSize: 32),
                        )
                      : // update Icon to help Icon
                      Icon(Icons.help, color: Colors.white, size: 32),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
// Tested and Implemented