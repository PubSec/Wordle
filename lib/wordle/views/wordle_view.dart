import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordle/app/app_colors.dart';
import 'package:wordle/wordle/data/word_list.dart';
import 'package:wordle/wordle/models/letter_model.dart';
import 'package:wordle/wordle/models/word_model.dart';
import 'package:wordle/wordle/widgets/board.dart';
import 'package:wordle/wordle/widgets/keyboard.dart';

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

  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
      6, (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()));

  int _currentWordIndex = 0;

  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  Word _solution = Word.fromString(
      fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase());

  final Set<Letter> _keyboardLetters = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "WORDLE",
          style: TextStyle(
            wordSpacing: 2,
            fontWeight: FontWeight.bold,
            fontSize: 36,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board, flipCardKeys: _flipCardKeys),
          const SizedBox(height: 80),
          Keyboard(
            onKeyTapped: _onKeyTapped,
            onDeleteTapped: _onDeleteTapped,
            onEnterTapped: _onEnterTapped,
            letters: _keyboardLetters,
          )
        ],
      ),
    );
  }

  void _onKeyTapped(String val) {
    if (_gameStatus == GameStatus.playing) {
      setState(() {
        _currentWord?.addLetter(val);
      });
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      setState(() {
        _currentWord?.removeLetter();
      });
    }
  }

  void _onEnterTapped() async {
    if (_gameStatus == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitting;
      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentWordLetter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];

        setState(
          () {
            if (currentWordLetter == currentSolutionLetter) {
              _currentWord!.letters[i] =
                  currentWordLetter.copyWith(status: LetterStatus.correct);
            } else if (_solution.letters.contains(currentWordLetter)) {
              _currentWord!.letters[i] =
                  currentWordLetter.copyWith(status: LetterStatus.inWord);
            } else {
              _currentWord!.letters[i] =
                  currentWordLetter.copyWith(status: LetterStatus.notInWord);
            }
          },
        );
        final letter = _keyboardLetters.firstWhere(
            (e) => e.val == currentWordLetter.val,
            orElse: () => Letter.empty());
        if (letter.status != LetterStatus.correct) {
          _keyboardLetters.removeWhere((e) => e.val == currentWordLetter.val);
          _keyboardLetters.add(_currentWord!.letters[i]);
        }
        await Future.delayed(
            const Duration(microseconds: 150),
            () =>
                _flipCardKeys[_currentWordIndex][i].currentState?.toggleCard());
      }
      _checkIfWinorLoss();
    }
  }

  void _checkIfWinorLoss() {
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(days: 1),
          backgroundColor: correctColor,
          content: Text(
            'You Won!',
            style: const TextStyle(color: Colors.white),
          ),
          dismissDirection: DismissDirection.none,
          action: SnackBarAction(
            label: "New Game",
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(days: 1),
        backgroundColor: correctColor,
        content: Text(
          'You Lost! Solution ${_solution.wordString}',
          style: const TextStyle(color: Colors.white),
        ),
        dismissDirection: DismissDirection.none,
        action: SnackBarAction(
          label: "New Game",
          onPressed: _restart,
          textColor: Colors.white,
        ),
      ));
    } else {
      _gameStatus = GameStatus.playing;
    }
    _currentWordIndex += 1;
  }

  void _restart() {
    _gameStatus = GameStatus.playing;
    _currentWordIndex = 0;
    _board
      ..clear()
      ..addAll(
        List.generate(
            6, (_) => Word(letters: List.generate(5, (_) => Letter.empty()))),
      );
    _solution = Word.fromString(
      fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
    );
    _flipCardKeys
      ..clear()
      ..addAll(List.generate(
          6, (_) => List.generate(5, (_) => GlobalKey<FlipCardState>())));
    _keyboardLetters.clear();
  }
}
