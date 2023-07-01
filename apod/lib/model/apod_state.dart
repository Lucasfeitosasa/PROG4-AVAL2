import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_keys.dart';
import 'apod_data.dart';

class DailyApodState extends ChangeNotifier {
  final String apodUrl = 'https://api.nasa.gov/planetary/apod';
  int _cardCount = 10;

  int get cardCount => _cardCount;

  set cardCount(int count) {
    _cardCount = count;
    notifyListeners();
  }

  List<ApodData> dailyApods = [];

  Future<void> fetchDailyApodData() async {
    Uri url =
        Uri.parse('$apodUrl?api_key=$apiKey&thumbs=true&count=$cardCount');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      try {
        final parsedResponse = json.decode(response.body) as List<dynamic>;
        dailyApods = parsedResponse
            .map((data) => ApodData.fromJson(data as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print('Erro ao decodificar o JSON: $e');
      }
    }

    notifyListeners();
  }
}
