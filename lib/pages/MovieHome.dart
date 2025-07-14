import 'package:flutter/material.dart';
import 'package:horror_recommender/pages/MovieDetails.dart';

import '../services/api_serv.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  _MovieHomePageState createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final MovieApiService _apiService = MovieApiService();

  Map<String, dynamic>? searchedMovie;
  List<Map<String, dynamic>> recommendedMovies = [];
  bool isLoading = false;

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter a movie name")));
      return;
    }

    setState(() {
      isLoading = true;
      searchedMovie = null;
      recommendedMovies.clear();
    });

    try {
      final movieId = await _apiService.searchMovieId(query);
      if (movieId == null) throw 'Movie Not Found';

      searchedMovie = await _apiService.getSingleMetadata(movieId);
      final recIds = await _apiService.getRecommendations(movieId);
      recommendedMovies = await _apiService.getMetadata(recIds);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        minTileHeight: 40,
        leading:
        movie['poster_path'] != null
            ? Image.network(
          'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
        )
            : null,
        title: Text(movie['title'] ?? 'No Title'),
        subtitle: Text(
          movie['overview'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Recommender')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              // Search box row - remains fixed at top
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search movie title...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(15.0),
                      ),
                      onEditingComplete: _search,
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: _search),
                ],
              ),
              SizedBox(height: 16),
              // Everything below wrapped in Expanded + SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading)
                        Container(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      if (!isLoading && searchedMovie != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Searched Movie",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildMovieCard(searchedMovie!),
                            SizedBox(height: 12),
                            Text(
                              "Recommended",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      if (!isLoading)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recommendedMovies.length,
                          itemBuilder: (context, index) {
                            return _buildMovieCard(recommendedMovies[index]);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

