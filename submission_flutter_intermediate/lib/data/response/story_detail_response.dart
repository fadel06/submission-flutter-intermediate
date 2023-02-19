import 'dart:convert';

import '../model/story.dart';

StoryDetailResponse storyDetailResponseFromJson(String str) =>
    StoryDetailResponse.fromJson(json.decode(str));

String storyDetailResponseToJson(StoryDetailResponse data) =>
    json.encode(data.toJson());

class StoryDetailResponse {
  StoryDetailResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  bool error;
  String message;
  Story story;

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      StoryDetailResponse(
        error: json["error"],
        message: json["message"],
        story: Story.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}
