import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'] ?? 'Movie Detail')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie['poster_path'] != null)
                Center(
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                  ),
                ),
              SizedBox(height: 16),
              Text(
                movie['title'] ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(movie['tagline']),
              SizedBox(height: 8),
              Text("Release Date: ${movie['release_date'] ?? 'N/A'}"),
              SizedBox(height: 12),
              Text(movie['overview'] ?? 'No description available.'),
            ],
          ),
        ),
      ),
    );
  }
}
