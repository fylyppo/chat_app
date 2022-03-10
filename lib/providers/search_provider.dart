import 'package:flutter/material.dart';

class Search with ChangeNotifier{
  final _searchController = TextEditingController();

  TextEditingController get searchController {
    return _searchController;
  }
  
  String get searchedText {
    return _searchController.text;
  }

  void change() {
    notifyListeners();
  }

@override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

}