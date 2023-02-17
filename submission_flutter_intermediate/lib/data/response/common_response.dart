import 'dart:convert';

class CommonResponse {
  final bool error;
  final String message;

  CommonResponse({
    required this.error,
    required this.message,
  });

  factory CommonResponse.fromMap(Map<String, dynamic> map) {
    return CommonResponse(
      error: map['error'] ?? false,
      message: map['message'] ?? '',
    );
  }

  factory CommonResponse.fromJson(String source) =>
      CommonResponse.fromMap(json.decode(source));
}
