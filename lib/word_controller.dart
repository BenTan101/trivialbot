import 'package:flutter/material.dart';

class WordController extends ChangeNotifier {
  static List<String> words = [];

  void addWord(String word) {
    words.add(word);
    notifyListeners();
  }

  void deleteWord(String word) {
    words.removeWhere((y) => y == word);
    notifyListeners();
  }

  String getWordsAsString() {
    return words.toString();
  }
}
