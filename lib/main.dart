import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/util/controllers.dart';

// 기존 import 유지
import 'view/login.dart'; 
import 'view/splash_screen.dart'; 
import 'view/shopping_cart.dart'; 
import 'view/order.dart';
import 'view/detail_view.dart'; // DetailScreen 임포트 유지

// Login 위젯의 클래스 이름이 Login인지 LoginScreen인지 확실하지 않아 LoginScreen을 가정합니다.
// 만약 'Login'이 맞다면 아래 GetPage에서 Login()으로 수정하세요.
import 'view/main_screen.dart'; // MainScreen 임포트 추가 (라우팅 테이블에 직접 포함되지 않아도 필요할 수 있음)


void main() {
  // 🚨 오류 수정 핵심: Flutter 엔진 바인딩이 완료된 후 Get.put을 실행하여 안정성을 보장합니다.
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. CartController 영구 등록 (기존 로직 유지)
  Get.put(CartController(), permanent: true); 
  
  // 2. 🚨 AppController 영구 등록 (누락된 부분 추가)
  Get.put(AppController(), permanent: true); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp 유지
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShoesHouse',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        fontFamily: 'Noto Sans KR',
        useMaterial3: true,
      ),
      
      // ------------------------------------------------------------------
      // GetX 라우팅 테이블 (기존 구성 유지)
      // ------------------------------------------------------------------
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        
        // Login 위젯 클래스 이름이 'Login'이라고 가정하고 수정
        GetPage(name: '/login', page: () => const Login()), // Login -> LoginScreen으로 클래스명 가정
        
        // DetailScreen (더미 인자 유지)
        GetPage(name: '/detail', page: () {
          // GetX 라우팅으로 진입 시 인자가 필요한 DetailScreen에 대한 처리
          return const DetailScreen(
             title: '상품', 
             subtitle: '브랜드', 
             price: '가격', 
             imageUrl: '',
          );
        }),

        // 장바구니 페이지 (ShoppingCart 클래스 이름이 ShoppingCart라고 가정)
        GetPage(name: '/cart', page: () => const ShoppingCart()),

        // 주문 페이지
        GetPage(name: '/order', page: () => const OrderScreen()),
      ],
      // ------------------------------------------------------------------
      
      // 시작 화면 유지
      home: const SplashScreen(), 
    );
  }
}