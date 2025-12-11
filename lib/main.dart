import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/util/controllers.dart';

// 패키지 경로는 본인의 프로젝트 구조에 맞게 유지하세요.
// 파일들이 같은 폴더에 있다면 아래처럼 import 해도 됩니다.
import 'view/login.dart'; 
import 'view/splash_screen.dart'; 

void main() {
  // 앱 실행 전에 컨트롤러를 등록하기 위해 바인딩을 실행합니다.
  // InitialBinding().dependencies(); 
  // (만약 다른 곳에서 Init Binding을 하지 않았다면, Get.put을 사용해도 됩니다.)
  Get.put(CartController(), permanent: true); // 앱 시작 시 CartController 영구 등록
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShoesHouse',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        fontFamily: 'Noto Sans KR',
        useMaterial3: true,
      ),
      // 핵심 변경 사항: 시작 화면을 SplashScreen으로 설정
      home: const SplashScreen(), 
    );
  }
}