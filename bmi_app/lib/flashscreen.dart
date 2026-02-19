import 'dart:async';

import 'package:bmi_app/firstpage.dart';
import 'package:bmi_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blueAccent,
        child: Center(
          child: Text(
            "BMI CAL...",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void checkLogin() async {
    var isLogin = await SharedPreferences.getInstance();
    var key = isLogin.getBool("isLogin");
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            if (key != null) {
              if (key) {
                return FirstPage();
              }
            }
            return LoginPage();
          },
        ),
      );
    });
  }
}
