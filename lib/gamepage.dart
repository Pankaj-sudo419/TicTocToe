import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game/score_board.dart';
import './models/game_button.dart';
import './dialoque_box.dart';

class GamePage extends StatefulWidget {
  static const routename = '/GamePage';
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  late List<Game_Button> buttonlist;
  late int game_style;
  var player1;
  var player2;
  var currentPlayer;
  var score1 = 0, score2 = 0;

  void initState() {
    super.initState();
    buttonlist = doInit();
  }

  List<Game_Button> doInit() {
    player1 = [];
    player2 = [];
    currentPlayer = 1;
    var gamebuttons = <Game_Button>[
      Game_Button(id: 1, bg: Colors.grey), // Assign a default color value
      Game_Button(id: 2, bg: Colors.grey),
      Game_Button(id: 3, bg: Colors.grey),
      Game_Button(id: 4, bg: Colors.grey),
      Game_Button(id: 5, bg: Colors.grey),
      Game_Button(id: 6, bg: Colors.grey),
      Game_Button(id: 7, bg: Colors.grey),
      Game_Button(id: 8, bg: Colors.grey),
      Game_Button(id: 9, bg: Colors.grey),
    ];
    return gamebuttons;
  }

  int winner = -1;
  int tie = 0;

  void resetGame() {
    //if (Navigator.canPop(context)) {
    if (winner == 1 || winner == 2 || tie == 1) {
      Navigator.pop(context);
      winner = -1;
    }
    setState(() {
      buttonlist = doInit();
    });
    buttonlist = doInit();
  }

  void checkwinner() {
    bool won_1 = false;
    bool won_2 = false;
    print(won_1);

    if ((player1.contains(1) && player1.contains(2) && player1.contains(3)) ||
        (player1.contains(4) && player1.contains(5) && player1.contains(6)) ||
        (player1.contains(7) && player1.contains(8) && player1.contains(9)) ||
        (player1.contains(1) && player1.contains(4) && player1.contains(7)) ||
        (player1.contains(2) && player1.contains(5) && player1.contains(8)) ||
        (player1.contains(3) && player1.contains(6) && player1.contains(9)) ||
        (player1.contains(1) && player1.contains(5) && player1.contains(9)) ||
        (player1.contains(3) && player1.contains(5) && player1.contains(7))) {
      print(won_1);
      winner = 1;
      setState(() {
        score1++;
      });
      showDialog(
          context: context,
          builder: (_) => DialogueBoxes(
                'Player 1 Won',
                'Reset to start the game again',
                resetGame,
              ));
    } else if ((player2.contains(1) &&
            player2.contains(2) &&
            player2.contains(3)) ||
        (player2.contains(4) && player2.contains(5) && player2.contains(6)) ||
        (player2.contains(7) && player2.contains(8) && player2.contains(9)) ||
        (player2.contains(1) && player2.contains(4) && player2.contains(7)) ||
        (player2.contains(2) && player2.contains(5) && player2.contains(8)) ||
        (player2.contains(3) && player2.contains(6) && player2.contains(9)) ||
        (player2.contains(1) && player2.contains(5) && player2.contains(9)) ||
        (player2.contains(3) && player2.contains(5) && player2.contains(7))) {
      print(won_2);
      winner = 2;
      setState(() {
        score2++;
      });
      showDialog(
          context: context,
          builder: (_) => DialogueBoxes(
                'Player 2 Won',
                'Reset to start the game again',
                resetGame,
              ));
    } else if (winner == -1) {
      if (buttonlist.every((p) => p.text != '')) {
        tie = 1;
        showDialog(
            context: context,
            builder: (_) => DialogueBoxes('Tie', 'The Game is Tie', resetGame));
      } else {
        (currentPlayer == 2 && game_style == 1) ? autoplay() : null;
      }
    }
  }

  void autoplay() {
    var emptyCells = [];

    var simpleList = List.generate(9, (i) => i + 1);
    for (var cell_no in simpleList) {
      if (!(player1.contains(cell_no) || player2.contains(cell_no))) {
        emptyCells.add(cell_no);
      }
    }
    var r = Random();
    var randIndex = r.nextInt((emptyCells.length - 1));
    var cell_no = emptyCells[randIndex];
    int i = buttonlist.indexWhere((p) => p.id == cell_no);
    button_pressed(buttonlist[i]);
  }

  void button_pressed(Game_Button gb) {
    setState(() {
      if (gb.enabled == true) {
        if (currentPlayer == 1) {
          gb.text = 'X';
          gb.bg = Theme.of(context).primaryColor;
          currentPlayer = 2;
          player1.add(gb.id);
        } else {
          gb.text = 'O';
          gb.bg =
              Theme.of(context).iconTheme.color!; // Access the color property
          currentPlayer = 1;
          player2.add(gb.id);
        }
        gb.enabled = false;
        checkwinner();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments;
    game_style = (routeArgs as Map<String, int>?)?["gamesstyle"] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              padding: const EdgeInsets.all(10),
              itemCount: buttonlist.length,
              itemBuilder: (context, index) => SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                  onPressed: buttonlist[index].enabled
                      ? () => button_pressed(buttonlist[index])
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: buttonlist[index].bg ?? Colors.grey,
                    disabledBackgroundColor:
                        buttonlist[index].bg ?? Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      buttonlist[index].text,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ScoreBoard(score1, score2),
          Container(
            child: ElevatedButton(
              child: Container(
                height: 60,
                child: Center(
                  child: Text(
                    'RESET THE GAME',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.grey,
                elevation: 2,
              ),
              onPressed: resetGame,
              //hoverColor: Colors.blue,
              //elevation: 2,
            ),
          )
        ],
      ),
    );
  }
}
