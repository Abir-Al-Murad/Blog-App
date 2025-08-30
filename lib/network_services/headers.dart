import 'package:blogs/network_services/auth_controller.dart';

class Headers {
  static Map<String, String> get logoutHeader => {
    "accept": "*/*",
    "Authorization": "Bearer ${AuthController.accessToken}",
  };

  static Map<String, String> get myPostsHeader => {
    "accept": "application/json",
    "Authorization": "Bearer ${AuthController.accessToken}",
  };
  static Map<String, String> get generalHeader => {
    "Content-Type": "application/json",
  };
  static Map<String,String>headerWithAuth = {
    'content-type':'application/json',
    "Authorization": "Bearer ${AuthController.accessToken ?? ''}",
  };
}