import 'package:flutter/material.dart';
import 'package:horror_recommender/pages/MovieHome.dart';

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Recommender',
      theme: ThemeData.dark(),
      home: MovieHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

