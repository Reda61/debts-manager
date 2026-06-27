import 'dart:async';
import 'dart:convert';

import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/models/api_response.dart';
import 'package:expenses4/data/models/person.dart';
import 'package:http/http.dart' as http;

class ClsPeopleApiService {
  //Post Data
  static Future<enStatusResponse> postPerson(
    clsPerson person,
    int currentUserID,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConstants.serverUrl}/People/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'id': person.id,
              'userID': currentUserID,
              'fullname': person.fullname,
              'phone': person.phone,
              'imagePath': person.imagepath,
              'updateAt': person.updateAt,
            }),
          )
          .timeout(Duration(seconds: 15));
      if (response.statusCode < 299) {
        return enStatusResponse.Ok;
      }
      if (response.statusCode == 404) {
        return enStatusResponse.NotFound;
      }

      if (response.statusCode == 400) {
        return enStatusResponse.BadRequest;
      }

      if (response.statusCode > 499) {
        return enStatusResponse.ServerError;
      }
      return enStatusResponse.localError;
    } on TimeoutException {
      return enStatusResponse.ServerError;
    } catch (e) {
      print("++++++++++++++++++++++++++++++++++++++++++++++");
      print(e);
      return enStatusResponse.localError;
    }
  }

  //Get Data
  static Future<ClsApiResponse> getAllPeople(int userID) async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.serverUrl}/People/All/$userID'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return ClsApiResponse(data: jsonDecode(response.body), isSuccess: true);
      }
      if (response.statusCode == 404) {
        return ClsApiResponse(data: [], isSuccess: true);
      }
      return ClsApiResponse(
        isSuccess: false,
        errorMessage: 'Server Error: ${response.statusCode}',
      );
    } on TimeoutException {
      return ClsApiResponse(isSuccess: false, errorMessage: 'timeout');
    } catch (e) {
      return ClsApiResponse(isSuccess: false, errorMessage: '$e');
    }
  }

  // Delete Data
  static Future<enStatusResponse> deletePerson(
    String personID,
    int userID,
  ) async {
    // if (jsonDecode(response.body)['result'] == 0) return enStatusResponse.NotFound;
    try {
      final response = await http
          .delete(
            Uri.parse('${AppConstants.serverUrl}/People/$personID/$userID'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 15));
      if (response.statusCode < 299) {
        return enStatusResponse.Ok;
      }
      if (response.statusCode == 404) {
        return enStatusResponse.NotFound;
      }

      if (response.statusCode == 400) {
        return enStatusResponse.BadRequest;
      }

      if (response.statusCode > 499) {
        return enStatusResponse.ServerError;
      }
      return enStatusResponse.localError;
    } on TimeoutException {
      return enStatusResponse.ServerError;
    } catch (e) {
      print("++++++++++++++++++++++++++++++++++++++++++++++");
      print(e.toString());
      return enStatusResponse.localError;
    }
  }
}
