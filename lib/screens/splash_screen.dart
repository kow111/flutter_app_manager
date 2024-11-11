import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent, // Màu nền của splash screen
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),

              // Tên nhóm hoặc ứng dụng
              Text(
                "App Manager 2nd hand",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Phạm Ngọc Thạch - 21110853",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              Text(
                "Triệu Nhật Nam - 21110251",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 20),

              // Hiển thị một thanh progress (đang tải)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
