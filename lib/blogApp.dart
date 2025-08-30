
import 'package:blogs/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Blogapp extends StatelessWidget {
  const Blogapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            filled:  true,
            fillColor: Colors.white70,
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.green
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.green
              ),
            ),
          ),
        ),
          home: SplashScreen(),
    );
  }
}
