import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Readwise',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const ReadwiseHome(),
    );
  }
}

class ReadwiseHome extends StatelessWidget {
  const ReadwiseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('ReadWise');
  }
}
