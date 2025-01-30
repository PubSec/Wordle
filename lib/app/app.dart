import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Wordle",
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const WordleScreen(),
    );
  }
}
