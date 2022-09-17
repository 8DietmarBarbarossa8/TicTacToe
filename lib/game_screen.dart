import 'package:flutter/material.dart';
import 'package:tic_tac_toe/color.dart';
import 'game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String player = Player.x;
  bool gameOver = false;
  int turn = 0;
  String result = '';
  List<int> scoreBoard = [for (int i = 0; i < 9; i++) 0];

  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
  }

  @override
  Widget build(BuildContext context) {
    double boardLength = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's $player turn.",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 58,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: boardLength,
            height: boardLength,
            child: GridView.count(
              crossAxisCount: Game.boardLength ~/ 3,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(Game.boardLength, (index) {
                return InkWell(
                  onTap: () {
                    if (!gameOver && game.board![index] == '') {
                      _processTap(index);
                    }
                  },
                  child: Container(
                    width: Game.blocSize,
                    height: Game.blocSize,
                    decoration: BoxDecoration(
                        color: MainColor.secondaryColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Text(
                        game.board![index],
                        style: TextStyle(
                            color: game.board![index] == Player.x
                                ? MainColor.xUserColor
                                : MainColor.oUserColor,
                            fontSize: 64),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            result,
            style: TextStyle(
              color: MainColor.white,
              fontSize: 54,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _restartGame(),
            icon: const Icon(Icons.replay),
            label: const Text(
              'Repeat the game',
            ),
          ),
        ],
      ),
    );
  }

  _processTap(int index) {
    setState(() {
      game.board![index] = player;
      turn++;
      gameOver = game.winnerCheck(player, index, scoreBoard, 3);
      if (gameOver) {
        result = '$player is the winner';
      } else if (!gameOver && turn == 9) {
        result = "It's a draw!";
        gameOver = true;
      }
      player = player == Player.x ? Player.o : Player.x;
    });
  }

  _restartGame() {
    setState(() {
      game.board = Game.initGameBoard();
      player = Player.x;
      gameOver = false;
      turn = 0;
      result = '';
      for (int i = 0; i < 9; i++) {
        scoreBoard[i] = 0;
      }
    });
  }
}
