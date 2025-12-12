import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_store_app_project/util/controllers.dart';

// 패키지 경로는 본인의 프로젝트 구조에 맞게 유지하세요.
// 파일들이 같은 폴더에 있다면 아래처럼 import 해도 됩니다.
import 'view/login.dart'; 
import 'view/splash_screen.dart'; 
import 'view/shopping_cart.dart'; 
import 'view/order.dart';
import 'view/detail_view.dart'; // DetailScreen도 라우팅 테이블에 포함시킬 경우

void main() {
  // 앱 실행 전에 컨트롤러를 등록하기 위해 바인딩을 실행합니다.
  // InitialBinding().dependencies(); 
  // (만약 다른 곳에서 Init Binding을 하지 않았다면, Get.put을 사용해도 됩니다.)
  Get.put(CartController(), permanent: true); // 앱 시작 시 CartController 영구 등록
  runApp(const MyApp());
}

// 기존 import 들은 그대로 유지

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
      // ------------------------------------------------------------------
      // 새로 추가된 GetX 라우팅 테이블
      // ------------------------------------------------------------------
      getPages: [
        // 스플래시 화면 (초기 라우트, GetX는 /를 기본으로 사용)
        GetPage(name: '/', page: () => const SplashScreen()),
        
        // 로그인 페이지
        GetPage(name: '/login', page: () => Login()),
        
        // 상세 페이지 (DetailScreen은 인자를 받으므로, 필요에 따라 Get.arguments로 처리할 수 있습니다.)
        // 현재는 Get.to(DetailScreen())으로 사용하셨을 가능성이 높지만, 이름을 정의해둡니다.
        // GetX 라우팅 시 Get.toNamed('/detail', arguments: {...}) 형식으로 사용 가능
        GetPage(name: '/detail', page: () => const DetailScreen(
             title: '상품', 
             subtitle: '브랜드', 
             price: '가격', 
             imageUrl: '',
             // 필수 인자를 더미로 채우거나, 라우팅 시 반드시 인자를 넘겨줘야 합니다.
             // 만약 Get.to(() => DetailScreen(...))으로 쓰신다면 이 라우트 정의는 불필요할 수도 있습니다.
        )),

        // 장바구니 페이지 (DetailScreen에서 Get.toNamed('/cart')로 호출됨)
        GetPage(name: '/cart', page: () => ShoppingCart()),

        // 주문 페이지 (DetailScreen에서 Get.toNamed('/order')로 호출됨)
        GetPage(name: '/order', page: () => const OrderScreen()),
      ],
      // ------------------------------------------------------------------
      home: const SplashScreen(), 
    );
  }
}