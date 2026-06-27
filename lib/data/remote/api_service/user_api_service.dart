import 'dart:async';
import 'dart:convert';

import 'package:expenses4/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;

class ClsUserApiService {
  // Post Or Get if it's found
  static Future<int?> postUser(
    String googleID,
    String email,
    String? name,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConstants.serverUrl}/Users'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'id': 0,
              'googleID': googleID,
              'email': email,
              'name': name,
            }),
          )
          .timeout(Duration(seconds: 15));
      if (response.statusCode < 205) {
        return int.parse(jsonDecode(response.body)['id'].toString());
      }
      return null;
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }

  // static Future<int?> getUserByEmail(String email) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${AppConstants.baseUrl}/Users/FindByEmail/$email'),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body)['id'];
  //     }
  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
