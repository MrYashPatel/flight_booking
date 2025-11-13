import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AirportService {
  static List<Map<String, String>>? _allAirports;

  /// Fetch airports from local JSON (static data)
  static Future<List<Map<String, String>>> fetchAirports(String query) async {
    // Load data if not already loaded
    if (_allAirports == null) {
      final raw = await rootBundle.loadString('assets/mock_airports.json');
      final List<dynamic> data = jsonDecode(raw);

      _allAirports = data
          .map((e) => {
        'name': e['name']?.toString() ?? '',
        'city': e['city']?.toString() ?? '',
        'country': e['country']?.toString() ?? '',
        'iata': e['code']?.toString() ?? '',
        'state': e['state']?.toString() ?? '',
        'icao': e['icao']?.toString() ?? '',
        'tz': e['tz']?.toString() ?? '',
        'lat': e['lat']?.toString() ?? '',
        'lon': e['lon']?.toString() ?? '',
      })
          .where((a) => a['name']!.isNotEmpty)
          .toList();
    }

    // Early return if query is empty
    if (query.trim().isEmpty) return [];

    final lowerQuery = query.toLowerCase();

    // Search logic: match name, city, code, or region
    final results = _allAirports!
        .where((airport) =>
    airport['name']!.toLowerCase().contains(lowerQuery) ||
        airport['city']!.toLowerCase().contains(lowerQuery) ||
        airport['country']!.toLowerCase().contains(lowerQuery) ||
        airport['state']!.toLowerCase().contains(lowerQuery) ||
        airport['iata']!.toLowerCase() == lowerQuery ||
        airport['icao']!.toLowerCase() == lowerQuery)
        .toList();

    // Sort by best match
    results.sort((a, b) {
      final aScore = _matchScore(a, lowerQuery);
      final bScore = _matchScore(b, lowerQuery);
      return aScore.compareTo(bScore);
    });
    return results;
  }

  static int _matchScore(Map<String, String> airport, String query) {
    final iata = airport['iata']!.toLowerCase();
    final icao = airport['icao']!.toLowerCase();
    final name = airport['name']!.toLowerCase();
    final city = airport['city']!.toLowerCase();
    final country = airport['country']!.toLowerCase();
    final state = airport['state']!.toLowerCase();

    if (iata == query || icao == query) return 0;
    if (name.contains(query)) return 1;
    if (city.contains(query)) return 2;
    if (state.contains(query)) return 3;
    if (country.contains(query)) return 4;
    return 5;
  }
}
