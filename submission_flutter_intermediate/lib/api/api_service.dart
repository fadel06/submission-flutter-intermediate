import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:submission_flutter_intermediate/data/response/common_response.dart';
import 'package:http/http.dart' as http;
import 'package:submission_flutter_intermediate/data/response/login_response.dart';
import 'package:submission_flutter_intermediate/data/response/story_detail_response.dart';
import 'package:submission_flutter_intermediate/data/response/story_response.dart';
import 'package:submission_flutter_intermediate/db/auth_repository.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  final AuthRepository authRepository = AuthRepository();

  Future<CommonResponse> register(
      String name, String email, String password) async {
    final endPointUri = Uri.parse('$_baseUrl/register');
    final Map<String, String> fields = {
      "name": name,
      "email": email,
      "password": password
    };

    final response = await http.post(endPointUri, body: fields);

    if (response.statusCode == 200) {
      final CommonResponse commonResponse =
          CommonResponse.fromJson(response.body);
      return commonResponse;
    } else {
      final CommonResponse commonResponse =
          CommonResponse.fromJson(response.body);
      throw Exception(commonResponse.message);
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    final endPointUri = Uri.parse('$_baseUrl/login');
    final Map<String, String> fields = {
      "email": email,
      "password": password,
    };

    final response = await http.post(endPointUri, body: fields);
    if (response.statusCode == 200) {
      return loginResponseFromJson(response.body);
    } else {
      throw Exception('Failed to Login');
    }
  }

  Future<StoryResponse> fetchStories() async {
    final endPointUri = Uri.parse('$_baseUrl/stories');
    final user = await authRepository.getUser();
    final response = await http.get(endPointUri,
        headers: {HttpHeaders.authorizationHeader: "Bearer ${user!.token}"});

    if (response.statusCode == 200) {
      return storyResponseFromJson(response.body);
    } else {
      final StoryResponse storyResponse = storyResponseFromJson(response.body);
      throw Exception(storyResponse.message);
    }
  }

  Future<StoryDetailResponse> fetchStoryDetail(String id) async {
    final endPointUri = Uri.parse('$_baseUrl/stories/$id');
    final user = await authRepository.getUser();
    final response = await http.get(endPointUri,
        headers: {HttpHeaders.authorizationHeader: "Bearer ${user!.token}"});

    if (response.statusCode == 200) {
      return storyDetailResponseFromJson(response.body);
    } else {
      final StoryDetailResponse storyResponse =
          storyDetailResponseFromJson(response.body);
      throw Exception(storyResponse.message);
    }
  }

  Future<CommonResponse> storeStory(
      List<int> bytes, String fileName, String description) async {
    final endPointUri = Uri.parse('$_baseUrl/stories');
    final user = await authRepository.getUser();

    final request = http.MultipartRequest('POST', endPointUri);
    final multiPartFile =
        http.MultipartFile.fromBytes('photo', bytes, filename: fileName);

    final Map<String, String> fields = {
      "description": description,
    };
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer ${user!.token}",
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final CommonResponse commonResponse = CommonResponse.fromJson(
        responseData,
      );
      return commonResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
