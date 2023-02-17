import 'package:submission_flutter_intermediate/data/response/common_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<CommonResponse> register(
      String name, String email, String password) async {
    final endPointUri = Uri.parse('$_baseUrl/register');
    final Map<String, String> fields = {
      "name": name,
      "email": email,
      "password": password
    };

    var response = await http.post(endPointUri, body: fields);

    if (response.statusCode == 201) {
      final CommonResponse commonResponse =
          CommonResponse.fromJson(response.body);
      return commonResponse;
    } else {
      throw Exception('Failed to Register');
    }
  }
}
