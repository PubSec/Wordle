import 'package:flutter/material.dart';
import 'package:wordle/wordle/models/letter_model.dart';

class BoardTile extends StatelessWidget {
  final Letter letter;
  const BoardTile({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      height: 48,
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: letter.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        letter.val,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
