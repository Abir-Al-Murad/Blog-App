import 'package:blogs/network_services/New/new_network_caller.dart';
import 'package:blogs/network_services/headers.dart';
import 'package:blogs/network_services/urls.dart';
import 'package:blogs/screens/home_screen.dart';
import 'package:blogs/screens/signInScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Icon(
              Icons.book,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),

            // App Name
            Text(
              "Blog App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),

            // Loading indicator
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _isLoggedIn() async {
    NewNetworkResponse response = await New_Network_Caller.getRequest(
        uri: Urls.profileInfo,
        header: Headers.headerWithAuth
    );
    if (response.isSuccess) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Signinscreen()));
    }
  }


}
