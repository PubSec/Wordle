import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordle/wordle/models/letter_model.dart';
import 'package:wordle/wordle/models/word_model.dart';
import 'package:wordle/wordle/widgets/board_tile.dart';

class Board extends StatelessWidget {
  final List<Word> board;
  final flipCardKeys;
  const Board({super.key, required this.board, this.flipCardKeys});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board
          .asMap()
          .map(
            (i, word) => MapEntry(
              i,
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: word.letters
                      .asMap()
                      .map(
                        (j, letter) => MapEntry(
                          j,
                          FlipCard(
                            key: flipCardKeys[i][j],
                            flipOnTouch: true,
                            direction: FlipDirection.VERTICAL,
                            front: BoardTile(
                                letter: Letter(
                                    val: letter.val,
                                    status: LetterStatus.initial)),
                            back: BoardTile(
                              letter: letter,
                            ),
                          ),
                        ),
                      )
                      .values
                      .toList()),
            ),
          )
          .values
          .toList(),
    );
  }
}
