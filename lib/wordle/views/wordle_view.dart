import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordle/wordle/data/word_list.dart';
import 'package:wordle/wordle/models/letter_model.dart';
import 'package:wordle/wordle/models/word_model.dart';

enum GameStatus { playing, submitting, lost, won }

class WordleView extends StatefulWidget {
  const WordleView({super.key});

  @override
  State<WordleView> createState() => _WordleViewState();
}

class _WordleViewState extends State<WordleView> {
  GameStatus _gameStatus = GameStatus.playing;

  final List<Word> _board = List.generate(
      6, (_) => Word(letters: List.generate(5, (_) => Letter.empty())));

  int _currentWordIndex = 0;

  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  final Word _solution = Word.fromString(
      fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Wordle",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 36,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
