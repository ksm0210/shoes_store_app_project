import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shoes_store_app_project/util/controllers.dart';
import 'package:shoes_store_app_project/view/auth/login.dart';
import 'package:shoes_store_app_project/view/order/shopping_cart.dart';
import 'package:shoes_store_app_project/view/product/product_detail.dart';
import 'package:shoes_store_app_project/view/splash_screen.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  
  // 1. CartController 영구 등록 (기존 로직 유지)
  Get.put(CartController(), permanent: true); 
  
  // 2. AppController 영구 등록 (누락된 부분 추가)
  Get.put(AppController(), permanent: true); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
       getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        
        // Login 위젯 클래스 이름이 'Login'이라고 가정하고 수정
        GetPage(name: '/login', page: () => const Login()), // Login -> LoginScreen으로 클래스명 가정
        
        // DetailScreen (더미 인자 유지)
        

        // 장바구니 페이지 (ShoppingCart 클래스 이름이 ShoppingCart라고 가정)
        GetPage(name: '/cart', page: () => ShoppingCartView()),

        // 주문 페이지
        // GetPage(name: '/order', page: () => const OrderScreen()),
      ],
      // home: const SplashScreen(),
    );
  }
}