import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_response.dart';

class SharedService{
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("login_details")!.isNotEmpty ? true : false;
  }

  static Future<LoginResponseModel?> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("login_details") != null
        ? LoginResponseModel.fromJson(jsonDecode(prefs.getString("login_details")!))
        : null;
  }

  static Future<Future<bool>> setLoginDetails(LoginResponseModel loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString("login_details", jsonEncode(loginResponse.toJson()));
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("login_details");
  }

}
