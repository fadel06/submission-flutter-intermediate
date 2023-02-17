import 'dart:developer';

import 'package:submission_flutter_intermediate/data/response/common_response.dart';
import 'package:http/http.dart' as http;
import 'package:submission_flutter_intermediate/model/user.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<CommonResponse> register(User user) async {
    final endPointUri = Uri.parse('$_baseUrl/register');
    final Map<String, String> fields = {
      "name": user.name!,
      "email": user.email!,
      "password": user.password!
    };

    var response = await http.post(endPointUri, body: fields);

    if (response.statusCode == 200) {
      final CommonResponse commonResponse =
          CommonResponse.fromJson(response.body);
      return commonResponse;
    } else {
      throw Exception(response.body);
    }
  }
}
