import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late List<String> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    _board = List.filled(9, '');
    _currentPlayer = 'X';
    _winner = '';
    _gameOver = false;
  }

  void _handleTap(int index) {
    if (_board[index] == '' && !_gameOver) {
      setState(() {
        _board[index] = _currentPlayer;
        _checkWinner();
        if (!_gameOver) {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  void _checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combo in winningCombinations) {
      if (_board[combo[0]] != '' &&
          _board[combo[0]] == _board[combo[1]] &&
          _board[combo[1]] == _board[combo[2]]) {
        setState(() {
          _winner = _board[combo[0]];
          _gameOver = true;
        });
        return;
      }
    }

    if (!_board.contains('')) {
      setState(() {
        _gameOver = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildBoard(),
          const SizedBox(height: 20),
          _buildInfoText(),
          const SizedBox(height: 20),
          _buildResetButton(),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
        ),
        itemBuilder: _buildGridItems,
        itemCount: 9,
      ),
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            _board[index],
            style: const TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    String infoText;
    if (_winner.isNotEmpty) {
      infoText = 'Jogador $_winner venceu!';
    } else if (_gameOver) {
      infoText = 'Empate!';
    } else {
      infoText = 'Vez do jogador $_currentPlayer';
    }
    return Text(
      infoText,
      style: const TextStyle(
        fontSize: 24.0,
      ),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _resetGame();
        });
      },
      child: const Text('Reiniciar'),
    );
  }
}
