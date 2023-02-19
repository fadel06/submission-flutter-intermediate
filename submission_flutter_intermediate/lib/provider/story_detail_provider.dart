import 'package:flutter/material.dart';
import 'package:submission_flutter_intermediate/data/response/story_detail_response.dart';

import '../api/api_service.dart';
import '../utils/constant.dart';

class StoryDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  StoryDetailProvider({required this.apiService, required this.id}) {
    _fetchStoryDetail(id);
  }

  late StoryDetailResponse _storyDetailResponse;
  StoryDetailResponse get story => _storyDetailResponse;

  late ResultState _state;
  ResultState get state => _state;

  late String _message;
  String get message => _message;

  Future<dynamic> _fetchStoryDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final data = await apiService.fetchStoryDetail(id);

      if (!data.error) {
        _state = ResultState.hasData;
        _storyDetailResponse = data;
        notifyListeners();
        return _storyDetailResponse;
      } else {
        _state = ResultState.error;
        _message = data.message;
        notifyListeners();
        return _message;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error --> $e';
      notifyListeners();
      return _message;
    }
  }
}
