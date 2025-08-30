import 'dart:convert';

import 'package:blogs/network_services/auth_controller.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewNetworkResponse{
  final int statuscode;
  final Map<String,dynamic>? body;
  final String? errormessage;
  final bool isSuccess;
  NewNetworkResponse({required this.statuscode,required this.isSuccess,this.body,this.errormessage});
}

class New_Network_Caller {
  static Future<NewNetworkResponse> postRequest({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? body,
    bool isFromLogin = false,
  }) async {
    try{
      final url = Uri.parse(uri);
      final encodedBody = jsonEncode(body);
      Response response =await post(url,headers: header,body: encodedBody);
      return _newHandleSystem(response,isFromLogin: isFromLogin);
    }catch(e){
      print('Error in NewNetworkCaller');
      return NewNetworkResponse(statuscode: -1, isSuccess: false,errormessage: 'from caller');
    }
  }

  static Future<NewNetworkResponse> putRequest({required String uri,required Map<String,dynamic> body,Map<String,String>?header})async{
    try{
      final url = Uri.parse(uri);
      final encodedBody = jsonEncode(body);
      Response response = await put(url,headers: header,body: encodedBody);
      return _newHandleSystem(response);

    }catch(e){
      return NewNetworkResponse(statuscode: -1, isSuccess: false,errormessage: 'from caller');

    }
  }
  static Future<NewNetworkResponse> getRequest({
    required String uri,
    Map<String, String>? header,
    Map<String, dynamic>? body,
    bool isFromLogin = false,
  }) async {
    try{
      final url = Uri.parse(uri);
      Response response =await get(url,headers: header);
      return _newHandleSystem(response,isFromLogin: isFromLogin);
    }catch(e){
      print('Error in NewNetworkCaller');
      return NewNetworkResponse(statuscode: -1, isSuccess: false,errormessage: 'from caller');
    }
  }

  static Future<NewNetworkResponse> _newHandleSystem(Response response,{bool isFromLogin = false})async{
    try{
      final decodedBody =jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode ==201){
        final prefs = await SharedPreferences.getInstance();
        if(isFromLogin){
          final setCookie = response.headers['set-cookie'];
          print('Your cookie - $setCookie');
          if (setCookie != null) {
            AuthController.saveRawToken(setCookie);
            final accessTokenMatch = RegExp(r'access_token=([^;]+)').firstMatch(setCookie);
            if (accessTokenMatch != null) {
              AuthController.accessToken = accessTokenMatch.group(1);
              prefs.setString('access_token', AuthController.accessToken!);
              print("Access Token : ${AuthController.accessToken}");
            }



            final refreshTokenMatch = RegExp(r'refresh_token=([^;]+)').firstMatch(setCookie);
            if (refreshTokenMatch != null) {
              AuthController.refreshToken = refreshTokenMatch.group(1);
              prefs.setString('refresh_token', AuthController.refreshToken!);
              print("Refresh Token : ${AuthController.refreshToken}");
            }
          }
        }
        return NewNetworkResponse(statuscode: response.statusCode, isSuccess: true,body: decodedBody);
      }else if(response.statusCode ==401){
        return NewNetworkResponse(statuscode: 401, isSuccess: false,errormessage: "Error is founded from newhandlesystem");
      }else{
        return NewNetworkResponse(statuscode: response.statusCode, isSuccess: false,body: decodedBody);
      }
    }catch(_){
      return NewNetworkResponse(statuscode: -1, isSuccess: false,errormessage: "Wrong in root");
    }
  }
}
