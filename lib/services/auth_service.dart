import 'package:app_route_map/preferences/user_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  Future<dynamic> login(String username, String password) async {
    UserPreference.init();
    final endpoint = "${dotenv.env['API_URL']}api/login";
    final data = {
      "params": {"user": username, "password": password}
    };
    var dio = Dio();
    final response = await dio.post(endpoint, data: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      if (data.keys.contains('result')) {
        Map<String, dynamic> result = data['result'];
        if (result.keys.contains('error')) {
          return {'message': result['error'], 'login': false};
        } else {
          UserPreference.putString('token', result['token']);
          UserPreference.putString('truck', result['truck']);
          UserPreference.putString('partner_name', result['partner_name']);
          UserPreference.putInteger('partner_id', result['partner_id']);
          return {'message': 'Login successful', 'login': true};
        }
      }
    }
    return {'message': 'Error in connection', 'login': false};
  }
}
