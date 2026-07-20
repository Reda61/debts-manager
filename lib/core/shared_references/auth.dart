import 'package:shared_preferences/shared_preferences.dart';

class ClsAuthData {
  static Future<void> saveUserID(int userID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userID', userID);
  }

  static Future<int?> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userID');
  }

  static Future<void> saveEmailUser(String emailUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailUser', emailUser);
  }

  static Future<String?> getEmailUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('emailUser');
  }

  static Future<void> clearDataAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('emailUser');
    await prefs.remove('userID');
  }
}
