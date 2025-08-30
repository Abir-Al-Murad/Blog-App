import 'dart:convert';
import 'package:blogs/Model/user_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static String? accessToken;
  static String? refreshToken;
  static String? csrfToken;
  static User_Model? user_model;
  static String? rawToken;
  static late SharedPreferences prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await loadStoredTokens();
  }

  // Extract tokens from response
  static void extractTokensFromResponse(Response response) {
    final setCookie = response.headers['set-cookie'];
    if (setCookie != null) {
      print("Extracting tokens from Set-Cookie: $setCookie");

      // access_token
      final accessTokenMatch = RegExp(r'access_token=([^;]+)').firstMatch(setCookie);
      if (accessTokenMatch != null) {
        accessToken = accessTokenMatch.group(1);
        prefs.setString('access_token', accessToken!);
        print("Extracted access token: ${accessToken!.substring(0, 20)}...");
      }

      // CSRF token
      final csrfMatch = RegExp(r'csrftoken=([^;]+)').firstMatch(setCookie);
      if (csrfMatch != null) {
        csrfToken = csrfMatch.group(1);
        prefs.setString('csrf_token', csrfToken!);
        print("Extracted CSRF token: $csrfToken");
      }

      // refresh_token
      final refreshTokenMatch = RegExp(r'refresh_token=([^;]+)').firstMatch(setCookie);
      if (refreshTokenMatch != null) {
        refreshToken = refreshTokenMatch.group(1);
        prefs.setString('refresh_token', refreshToken!);
        print("Extracted refresh token: ${refreshToken!.substring(0, 20)}...");
      }
    } else {
      print("No Set-Cookie header in response");
    }
  }

  static Future<void> loadStoredTokens() async {
    accessToken = prefs.getString('access_token');
    refreshToken = prefs.getString('refresh_token');
    csrfToken = prefs.getString('csrf_token');

    print("Loaded tokens from storage:");
    print("Access Token: ${accessToken != null ? '${accessToken!.substring(0, 20)}...' : 'null'}");
    print("Refresh Token: ${refreshToken != null ? '${refreshToken!.substring(0, 20)}...' : 'null'}");
    print("CSRF Token: $csrfToken");
  }

  static void clearData() {
    accessToken = null;
    refreshToken = null;
    csrfToken = null;
    user_model = null;
    prefs.remove('access_token');
    prefs.remove('refresh_token');
    prefs.remove('csrf_token');
    prefs.remove('user_model');
    print("All auth data cleared");
  }

  // Save user model
  static void saveUserModel(User_Model user) {
    prefs.setString('user_model', json.encode(user.toJson()));
    user_model = user;
  }
  static void saveRawToken(String token) {
    prefs.setString('raw_token', token);
    rawToken = token;
  }

  // Load user model
  static Future<void> loadUserModel() async {
    final userModelString = prefs.getString('user_model');
    if (userModelString != null) {
      user_model = User_Model.fromJson(json.decode(userModelString));
    }
  }


}