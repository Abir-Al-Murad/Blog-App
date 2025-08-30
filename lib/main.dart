import 'package:blogs/blogApp.dart';
import 'package:blogs/network_services/auth_controller.dart';
import 'package:flutter/cupertino.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await AuthController.init();
  runApp(Blogapp());
}
