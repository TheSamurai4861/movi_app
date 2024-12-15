import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static final tmdbApiKey = dotenv.env['TMDB_API_KEY'] ?? '';
}

class Api {
  static const String apiUrl = 'https://movi-resolver.vercel.app/';
  static const String apiTMDBMovie = 'https://api.themoviedb.org/3/movie/';
}