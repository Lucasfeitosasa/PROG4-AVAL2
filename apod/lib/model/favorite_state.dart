import 'package:flutter/material.dart';
import 'apod_data.dart';

class FavoriteState extends ChangeNotifier {
  List<ApodData> favoriteList = [];

  void addToList(ApodData apodData) {
    favoriteList.add(apodData);
    notifyListeners();
  }

  void removeFromList(ApodData apodData) {
    favoriteList.remove(apodData);
    notifyListeners();
  }
}
