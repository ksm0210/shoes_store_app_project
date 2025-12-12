import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/util/global_login_data.dart';
import 'package:shoes_store_app_project/util/initializeData.dart';
import 'package:shoes_store_app_project/view/auth/login.dart';
import 'package:shoes_store_app_project/view/home.dart';
import 'package:shoes_store_app_project/vm/category_handler.dart';
// import 'login.dart'; // 1. 로그인 페이지를 import 해야 합니다.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CategoryHandler categoryHandler = CategoryHandler();

  @override
  void initState() {
    super.initState();

    initData();
    // 2초 후 로그인 화면으로 이동
    Future.delayed(const Duration(seconds: 2), () {
      // 2. '/login' 문자열 경로 대신 클래스로 직접 이동하게 수정
      // 이렇게 하면 main.dart에 복잡한 라우트 설정이 없어도 바로 넘어갑니다.

      Get.off(() => GlobalLoginData.isLogin ? const Home() : const Login());
    });
  }

  initData() async {
    await initializeData();
    GlobalLoginData.categories = await categoryHandler.selectQuery();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 세련된 로고 디자인 (아이콘과 텍스트)
            Icon(
              Icons.shop_two_outlined, // 신발 관련 아이콘
              color: Colors.white,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              "STITCH DESIGN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Walk in Style",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
