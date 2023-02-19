import 'package:flutter/material.dart';
import 'package:submission_flutter_intermediate/db/auth_repository.dart';

import '../api/api_service.dart';
import '../data/response/story_response.dart';
import '../utils/constant.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiService apiService;

  StoryListProvider({required this.apiService}) {
    _fetchStories();
  }

  late StoryResponse _storyResponse;
  StoryResponse get list => _storyResponse;

  late ResultState _state;
  ResultState get state => _state;

  late String _message;
  String get message => _message;

  Future<dynamic> _fetchStories() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final response = await apiService.fetchStories();
      if (response.listStory.isNotEmpty) {
        _state = ResultState.hasData;
        _storyResponse = response;
        notifyListeners();
        return _storyResponse;
      } else if (response.listStory.isEmpty) {
        _state = ResultState.noData;
        _message = response.message;
        notifyListeners();
        return _message;
      } else {
        _state = ResultState.error;
        _message = response.message;
        notifyListeners();
        return _message;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
      return _message;
    }
  }
}
